# Versions of sanitize_email > 1 no longer require actionmailer, and can be used sans-rails.
require 'actionmailer'

require "sanitize_email/version"
require 'sanitize_email/sanitize_email'
require 'sanitize_email/custom_environments'

module SanitizeEmail
end

ActionMailer::Base.send :include, NinthBit::CustomEnvironments
ActionMailer::Base.send :include, NinthBit::SanitizeEmail
