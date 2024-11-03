# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/lib/jmeter_perf/dsl/"
end

require "jmeter_perf"
require "jmeter_perf/rspec_matchers"

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |f| require f }
RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
