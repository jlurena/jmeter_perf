# frozen_string_literal: true

require_relative "lib/jmeter_perf/version"

Gem::Specification.new do |spec|
  spec.name = "jmeter_perf"
  spec.version = JmeterPerf::VERSION
  spec.authors = ["Jean Luis Urena"]
  spec.email = ["eljean@live.com"]
  spec.license = "MIT"

  spec.summary = "Run performance tests for your Ruby project using JMeter"
  spec.description = "Run performance tests, generate reports and more using JMeter"
  spec.homepage = "https://github.com/jlurena/jmeter_perf"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jlurena/jmeter_perf"
  spec.metadata["changelog_uri"] = "https://github.com/jlurena/jmeter_perf/blob/main/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1.16", ">= 1.16.7"
  spec.add_dependency "tdigest", "~> 0.2.1"
end
