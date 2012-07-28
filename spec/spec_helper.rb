require 'sanitize_email'
require 'launchy'
require 'mail'
require 'rails'
require 'letter_opener'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  #config.filter_run :focus
end

RSpec::Matchers.define :have_from do |from|
  match do |container|
    container =~ Regexp.new(Regexp.escape(from))
  end
end
RSpec::Matchers.define :have_to do |to|
  match do |container|
    container =~ Regexp.new(Regexp.escape(to))
  end
end
RSpec::Matchers.define :have_cc do |cc|
  match do |container|
    container =~ Regexp.new(Regexp.escape(cc))
  end
end
# The ActionMailer :file delivery method never prints bcc recipients...
#   so not testable as such, but with letter_opener we can work magic
RSpec::Matchers.define :have_bcc do |bcc|
  match do |container|
    container =~ Regexp.new(Regexp.escape(bcc))
  end
end
RSpec::Matchers.define :have_subject do |subject|
  match do |container|
    container =~ Regexp.new(Regexp.escape(subject))
  end
end
