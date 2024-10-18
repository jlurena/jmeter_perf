module JmeterPerf
  class ExtendedDSL < DSL
    include Parser
    attr_accessor :root

    def initialize(params = {})
      @root = Nokogiri::XML(<<-EOF.strip_heredoc)
        <?xml version="1.0" encoding="UTF-8"?>
        <jmeterTestPlan version="1.2" properties="3.1" jmeter="3.1" ruby-jmeter="3.0">
        <hashTree>
        </hashTree>
        </jmeterTestPlan>
      EOF
      node = JmeterPerf::TestPlan.new(params)

      @current_node = @root.at_xpath("//jmeterTestPlan/hashTree")
      @current_node = attach_to_last(node)
    end

    def out
      puts to_xml
    end

    def to_doc
      doc.clone
    end

    def jmx(out_jmx: "ruby-jmeter.jmx")
      File.write(out_jmx, to_xml)
      logger.info "JMX saved to: #{out_jmx}"
    end

    def to_xml
      doc.to_xml(indent: 2)
    end

    def run(
      name: "ruby-jmeter",
      jmeter_path: "jmeter",
      out_jmx: "ruby-jmeter.jmx",
      out_jtl: "jmeter.jtl",
      out_jmeter_log: "jmeter.log",
      out_cmd_log: "jmeter-cmd.log"
    )
      jmx(out_jmx:)
      logger.warn "Executing #{out_jmx} test plan locally ..."

      cmd = <<~CMD.strip
        #{jmeter_path} -n -t #{out_jmx} -j #{out_jmeter_log} -l #{out_jtl}
      CMD

      summary = JmeterPerf::Report::Summary.new(out_jtl, name)
      jtl_process_thread = summary.stream_jtl_async

      File.open(out_cmd_log, "w") do |f|
        # Redirect both stdout and stderr to the log file
        pid = Process.spawn(cmd, out: f, err: [:child, :out])
        Process.waitpid(pid)
      end

      summary.finish!         # Notify jtl collection jtl cmd finished
      jtl_process_thread.join # Join main thread and wait for it to finish

      # Check exit status after the process has completed
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

    def hash_tree
      Nokogiri::XML::Node.new("hashTree", @root)
    end

    def attach_to_last(node)
      ht = hash_tree
      last_node = @current_node
      last_node << node.doc.children << ht
      ht
    end

    def attach_node(node, &block)
      ht = attach_to_last(node)
      previous = @current_node
      @current_node = ht
      instance_exec(&block) if block
      @current_node = previous
    end

    def doc
      Nokogiri::XML(@root.to_s, &:noblanks)
    end

    def logger
      return @logger if @logger
      @logger = Logger.new($stdout)
      @logger.level = Logger::DEBUG
      @logger
    end
  end
end
