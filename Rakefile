# encoding: utf-8
#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rake"

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
  task :default => :spec
rescue LoadError
end

require "reek/rake/task"
Reek::Rake::Task.new do |t|
  t.fail_on_error = true
  t.verbose = false
  t.source_files = "lib/**/*.rb"
end

require "roodi"
require "roodi_task"
RoodiTask.new do |t|
  t.verbose = false
end

namespace :test do
  desc "Test against all supported Rails versions"
  task :all do
    %w(3.0.x 3.1.x 3.2.x 4.0.x 4.1.x 4.2.x).each do |version|
      sh %[BUNDLE_GEMFILE="gemfiles/Gemfile.rails-#{version}" bundle --quiet]
      sh %[BUNDLE_GEMFILE="gemfiles/Gemfile.rails-#{version}" bundle exec rspec spec]
    end
  end
end

require File.expand_path("../lib/sanitize_email/version", __FILE__)
require "rdoc"
require "rdoc/task"
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title    = "SanitizeEmail #{SanitizeEmail::VERSION}"
  rdoc.options << "--line-numbers"
  rdoc.rdoc_files.include("README*")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

Bundler::GemHelper.install_tasks
