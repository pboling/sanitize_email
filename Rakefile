require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "sanitize_email"
    gemspec.summary = "Tool to aid in development, testing, qa, and production troubleshooting of email issues without worrying that emails will get sent to actual live addresses."
    gemspec.description = %q{Test an application's email abilities without ever sending a message to actual live addresses}
    gemspec.email = ['peter.boling@gmail.com', 'jtrupiano@gmail.com', 'george@benevolentcode.com']
    gemspec.homepage = "http://github.com/pboling/sanitize_email"
    gemspec.authors = ["Peter Boling", "John Trupiano", "George Anderson"]
    gemspec.add_dependency 'actionmailer'
    gemspec.files = ["lib/sanitize_email/custom_environments.rb",
             "lib/sanitize_email/sanitize_email.rb",
             "lib/sanitize_email.rb",
             "init.rb",
             "MIT-LICENSE",
             "Rakefile",
             "README.rdoc",
             "sanitize_email.gemspec",
             "VERSION.yml",
             "test/sample_mailer.rb",
             "test/sanitize_email_test.rb"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
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
Rake::RDocTask.new do |rdoc|
  config = YAML.load(File.read('VERSION.yml'))
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sanitize_email #{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# Rubyforge documentation task
begin
  require 'rake/contrib/sshpublisher'
  namespace :rubyforge do
    
    desc "Release gem and RDoc documentation to RubyForge"
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]
    
    namespace :release do
      desc "Publish RDoc to RubyForge."
      task :docs => [:rdoc] do
        config = YAML.load(
          File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )

        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/johntrupiano/sanitize_email/"
        local_dir = 'rdoc'

        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end
