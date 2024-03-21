# frozen_string_literal: true

require "bundler/gem_tasks"

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new
  desc("alias spec => test")
  task(spec: :test)
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
  warn("Failed to load reek")
end

begin
  require "roodi"
  require "roodi_task"
  RoodiTask.new do |t|
    t.verbose = false
  end
rescue LoadError
  warn("Failed to load roodi")
end

require "lib/sanitize_email/version"
require "rdoc"
require "rdoc/task"
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "SanitizeEmail #{SanitizeEmail::VERSION}"
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

task default: %i[spec rubocop_gradual]
