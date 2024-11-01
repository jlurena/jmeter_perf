# frozen_string_literal: true

require_relative "jmeter_perf/version"
lib = File.dirname(File.absolute_path(__FILE__))

Dir.glob(File.join(lib, "jmeter_perf/report/*.rb")).each do |file|
  require_relative file
end

Dir.glob(File.join(lib, "jmeter_perf/helpers/*.rb")).each do |file|
  require_relative file
end

Dir.glob(File.join(lib, "jmeter_perf/dsl/*.rb")).each do |file|
  require_relative file
end

Dir.glob(File.join(lib, "jmeter_perf/extend/**/*.rb")).each do |file|
  require_relative file
end

Dir.glob(File.join(lib, "jmeter_perf/plugins/*.rb")).each do |file|
  require_relative file
end

# JmeterPerf module for handling performance testing with JMeter.
# This module provides methods to define and execute JMeter test plans.
module JmeterPerf
  # Evaluates the test plan with the given parameters and block.
  # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation DSL Documentation
  # @param params [Hash] Parameters for the test plan (default: `{}`).
  # @yield The block to define the test plan steps.
  # @return [JmeterPerf::ExtendedDSL] The DSL instance with the configured test plan.
  def self.test(params = {}, &block)
    dsl = JmeterPerf::ExtendedDSL.new(params)

    block_context = eval("self", block.binding, __FILE__, __LINE__)
    proxy_context = JmeterPerf::Helpers::FallbackContextProxy.new(dsl, block_context)
    begin
      block_context.instance_variables.each do |ivar|
        proxy_context.instance_variable_set(ivar, block_context.instance_variable_get(ivar))
      end
      proxy_context.instance_eval(&block)
    ensure
      block_context.instance_variables.each do |ivar|
        block_context.instance_variable_set(ivar, proxy_context.instance_variable_get(ivar))
      end
    end
    dsl
  end

  # DSL class for defining JMeter test plans.
  # Provides methods to generate, save, and run JMeter tests.
  class ExtendedDSL < DSL
    include JmeterPerf::Helpers::Parser
    attr_accessor :root

    # Initializes an ExtendedDSL object with the provided parameters.
    # @param params [Hash] Parameters for the test plan (default: `{}`).
    def initialize(params = {})
      @root = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
        <<-EOF
          <?xml version="1.0" encoding="UTF-8"?>
          <jmeterTestPlan version="1.2" properties="3.1" jmeter="3.1" ruby-jmeter="3.0">
          <hashTree>
          </hashTree>
          </jmeterTestPlan>
        EOF
      ))
      node = JmeterPerf::DSL::TestPlan.new(params)
      @current_node = @root.at_xpath("//jmeterTestPlan/hashTree")
      @current_node = attach_to_last(node)
    end

    # Saves the test plan as a JMX file.
    #
    # @param out_jmx [String] The path for the output JMX file (default: `"ruby-jmeter.jmx"`).
    def jmx(out_jmx: "ruby-jmeter.jmx")
      File.write(out_jmx, doc.to_xml(indent: 2))
      logger.info "JMX saved to: #{out_jmx}"
    end

    # Runs the test plan with the specified configuration.
    #
    # @param name [String] The name of the test run (default: `"ruby-jmeter"`).
    # @param jmeter_path [String] Path to the JMeter executable (default: `"jmeter"`).
    # @param out_jmx [String] The filename for the output JMX file (default: `"ruby-jmeter.jmx"`).
    # @param out_jtl [String] The filename for the output JTL file (default: `"jmeter.jtl"`).
    # @param out_jmeter_log [String] The filename for the JMeter log file (default: `"jmeter.log"`).
    # @param out_cmd_log [String] The filename for the command log file (default: `"jmeter-cmd.log"`).
    # @param jtl_read_timeout [Integer] The maximum number of seconds to wait for a line read (default: `3`).
    # @return [JmeterPerf::Report::Summary] The summary report of the test run.
    # @raise [RuntimeError] If the test execution fails.
    def run(
      name: "ruby-jmeter",
      jmeter_path: "jmeter",
      out_jmx: "ruby-jmeter.jmx",
      out_jtl: "jmeter.jtl",
      out_jmeter_log: "jmeter.log",
      out_cmd_log: "jmeter-cmd.log",
      jtl_read_timeout: 3
    )
      jmx(out_jmx:)
      logger.warn "Executing #{out_jmx} test plan locally ..."

      cmd = <<~CMD.strip
        #{jmeter_path} -n -t #{out_jmx} -j #{out_jmeter_log} -l #{out_jtl}
      CMD

      summary = JmeterPerf::Report::Summary.new(file_path: out_jtl, name:, jtl_read_timeout:)
      jtl_process_thread = summary.stream_jtl_async

      File.open(out_cmd_log, "w") do |f|
        pid = Process.spawn(cmd, out: f, err: [:child, :out])
        Process.waitpid(pid)
      end

      summary.finish!         # Notify jtl collection that JTL cmd finished
      jtl_process_thread.join # Join main thread and wait for it to finish

      unless $?.exitstatus.zero?
        logger.error("Failed to run #{cmd}. See #{out_cmd_log} and #{out_jmeter_log} for details.")
        raise "Exit status: #{$?.exitstatus}"
      end

      summary.summarize_data!
      logger.info "[Test Plan Execution Completed Successfully] JTL saved to: #{out_jtl}\n"
      summary
    rescue
      summary.finish!
      raise
    end

    private

    # Creates a new hash tree node for the JMeter test plan.
    #
    # @return [Nokogiri::XML::Node] A new hash tree node.
    def hash_tree
      Nokogiri::XML::Node.new("hashTree", @root)
    end

    # Attaches a node as the last child of the current node.
    #
    # @param node [Object] The node to attach.
    # @return [Object] The hash tree for the attached node.
    def attach_to_last(node)
      ht = hash_tree
      last_node = @current_node
      last_node << node.doc.children << ht
      ht
    end

    # Attaches a node and evaluates the block within its context.
    #
    # @param node [Object] The node to attach.
    # @yield The block to be executed in the node's context.
    def attach_node(node, &block)
      ht = attach_to_last(node)
      previous = @current_node
      @current_node = ht
      instance_exec(&block) if block
      @current_node = previous
    end

    # Returns the Nokogiri XML document.
    #
    # @return [Nokogiri::XML::Document] The XML document for the JMeter test plan.
    def doc
      Nokogiri::XML(@root.to_s, &:noblanks)
    end

    # Logger instance to log messages to the standard output.
    #
    # @return [Logger] The logger instance, initialized to DEBUG level.
    def logger
      return @logger if @logger
      @logger = Logger.new($stdout)
      @logger.level = Logger::DEBUG
      @logger
    end
  end
end
