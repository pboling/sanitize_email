require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "sanitize_email"
    s.summary = "Gemified fork of pboling's sanitize_email plugin: allows you to play with your application's email abilities without worrying that emails will get sent to actual live addresses."
    s.email = "jtrupiano@gmail.com"
    s.homepage = "http://github.com/jtrupiano/sanitize_email"
    s.description = "allows you to play with your application's email abilities without worrying that emails will get sent to actual live addresses"
    s.authors = ["John Trupiano", "Peter Boling"]
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the sanitize_email plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the sanitize_email plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SanitizeEmail'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

