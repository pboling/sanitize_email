require 'rubygems'

require 'test/unit'

RAILS_ROOT = '.' unless defined?(RAILS_ROOT)
RAILS_ENV = 'test'

require File.join(File.dirname(__FILE__), "..", "init")

# configure ActionMailer
ActionMailer::Base.template_root = File.join(File.dirname(__FILE__), "test")
ActionMailer::Base.sanitized_recipients = "test@example.com"
ActionMailer::Base.sanitized_bcc = nil
ActionMailer::Base.sanitized_cc = nil

require 'test/sample_mailer'
