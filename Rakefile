require 'bundler'
require "bundler/gem_tasks"

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  Bundler.require(:development)
  spec.pattern = FileList['spec/**/*_spec.rb']
end
