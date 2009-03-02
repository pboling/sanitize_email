require File.join(File.dirname(__FILE__), "sanitize_email", "sanitize_email")
require File.join(File.dirname(__FILE__), "sanitize_email", "custom_environments")

ActionMailer::Base.send :include, NinthBit::CustomEnvironments
ActionMailer::Base.send :include, NinthBit::SanitizeEmail
