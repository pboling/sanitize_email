require File.join(File.dirname(__FILE__), 'lib', "sanitize_email", "custom_environments")
require File.join(File.dirname(__FILE__), 'lib', "sanitize_email", "sanitize_email")

$:.unshift "#{File.dirname(__FILE__)}/lib"

require 'action_mailer'
require 'sanitize_email'
