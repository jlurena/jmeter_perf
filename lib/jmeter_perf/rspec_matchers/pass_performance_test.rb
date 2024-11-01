# Provides a custom matcher to use with RSpec to test performance tests
# Usage:
#  require 'jmeter_perf/rspec_matchers'
#  comparator = JmeterPerf::Report::Comparator.new(base_summary, test_summary)
#  expect(comparator).to pass_performance
#  expect(comparator).to pass_performance.with_effect_size(:small)
#  expect(comparator).to pass_performance.with_direction(:positive)
#  expect(comparator).to pass_performance.with_cohen_d_limit(0.2)
#  expect(comparator).to pass_performance.with(effect_size: :small, direction: :positive, cohen_limit: 0.2)
RSpec::Matchers.define :pass_performance_test do
  description { "Passes performance test" }
  chain :with_effect_size do |effect_size|
    @effect_size = effect_size
  end

  chain :with_direction do |direction|
    @direction = direction
  end

  chain :with_cohen_d_limit do |limit|
    @cohen_limit = limit
  end

  chain :with do |options|
    @effect_size = options[:effect_size]
    @direction = options[:direction]
    @cohen_limit = options[:cohen_limit]
  end

  match do |comparator|
    if comparator.is_a?(JmeterPerf::Report::Comparator)
      comparator.pass?(
        cohens_d_limit: @cohen_limit || nil,
        effect_size: @effect_size || :vsmall,
        direction: @direction || :both
      )
    else
      false
    end
  end

  failure_message do |comparator|
    if comparator.is_a?(JmeterPerf::Report::Comparator)
      "#{comparator.name} failed: #{comparator.cohens_d} | #{comparator.human_rating}"
    else
      "#{comparator.class.name} is not a valid comparator"
    end
  end

  failure_message_when_negated do |comparator|
    if comparator.is_a?(JmeterPerf::Report::Comparator)
      "#{comparator.name} passed: #{comparator.cohens_d} | #{comparator.human_rating}"
    else
      "#{comparator.class.name} is not a valid comparator"
    end
  end
end
