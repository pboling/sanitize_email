require "sanitize_email/rspec_matchers"

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.include SanitizeEmail::RspecMatchers
end
