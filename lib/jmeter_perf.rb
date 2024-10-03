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
end
