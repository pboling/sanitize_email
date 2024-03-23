# frozen_string_literal: true

require "bundler/gem_tasks"

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
  desc "alias test task to spec"
  task test: :spec
rescue LoadError
  warn("Failed to load rspec")
end

begin
  require "reek/rake/task"
  Reek::Rake::Task.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = "lib/**/*.rb"
  end
rescue LoadError
  warn("reek is not installed")
end

require_relative "lib/sanitize_email/version"
require "rdoc"
require "rdoc/task"
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "SanitizeEmail #{SanitizeEmail::Version::VERSION}"
  rdoc.options << "--line-numbers"
  rdoc.rdoc_files.include("README*")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

begin
  require "rubocop/lts"
  Rubocop::Lts.install_tasks
rescue LoadError
  puts "Linting not available"
end

task default: %i[spec reek rubocop_gradual]
