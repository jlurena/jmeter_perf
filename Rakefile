# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "standard/rake"
Dir.glob("lib/tasks/*.rake").each { |r| load r }

RSpec::Core::RakeTask.new(:spec)

task default: [:standard, :spec]
