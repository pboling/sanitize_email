require 'rubygems'

vendored_rails = File.dirname(__FILE__) + '/../../../../vendor/rails'
if File.exists?(vendored_rails)
  Dir.glob(vendored_rails + "/**/lib").each { |dir| $:.unshift dir }
  RAILS_ROOT = File.dirname(__FILE__) + '/../../../../' unless defined?(RAILS_ROOT)
else
  gem 'rails', "=#{ENV['VERSION']}" if ENV['VERSION']
  RAILS_ROOT = '.' unless defined?(RAILS_ROOT)
end

require 'test/unit'

RAILS_ENV = 'test'

require File.join(File.dirname(__FILE__), "..", "init")

# configure ActionMailer
ActionMailer::Base.template_root = File.join(File.dirname(__FILE__), "test")
ActionMailer::Base.sanitized_recipients = "test@example.com"
ActionMailer::Base.sanitized_bcc = nil
ActionMailer::Base.sanitized_cc = nil

require File.expand_path(File.dirname(__FILE__) + '/sample_mailer')
