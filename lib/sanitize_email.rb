require 'action_mailer'
require 'sanitize_email/sanitize_email'
require 'sanitize_email/custom_environments'

ActionMailer::Base.send :include, NinthBit::CustomEnvironments
ActionMailer::Base.send :include, NinthBit::SanitizeEmail
