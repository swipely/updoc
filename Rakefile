require "bundler/gem_tasks"
require 'rspec/core/rake_task'

namespace :build do
  RSpec::Core::RakeTask.new(:spec)

  task spec_and_quality: [:spec]
end

task default: ['build:spec_and_quality']
