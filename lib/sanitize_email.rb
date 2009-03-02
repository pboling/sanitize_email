require "sanitize_email"
require "custom_environments"

ActionMailer::Base.send :include, NinthBit::CustomEnvironments
ActionMailer::Base.send :include, NinthBit::SanitizeEmail
