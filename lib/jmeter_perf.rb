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

require_relative "jmeter_perf/dsl"

module JmeterPerf
  def self.test(params = {}, &)
    JmeterPerf.dsl_eval(JmeterPerf::ExtendedDSL.new(params), &)
  end

  def self.dsl_eval(dsl, &block)
    block_context = eval("self", block.binding, __FILE__, __LINE__)
    proxy_context = JmeterPerf::FallbackContextProxy.new(dsl, block_context)
    begin
      block_context.instance_variables.each { |ivar| proxy_context.instance_variable_set(ivar, block_context.instance_variable_get(ivar)) }
      proxy_context.instance_eval(&block)
    ensure
      block_context.instance_variables.each { |ivar| block_context.instance_variable_set(ivar, proxy_context.instance_variable_get(ivar)) }
    end
    dsl
  end
end
