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

module EmailMatcherHelpers
  class UnexpectedMailType < StandardError; end

  # Sweet, nourishing recursion
  def email_matching(matcher, part, mail_or_part)
    if mail_or_part.respond_to?(part)
      email_matching(matcher, part, mail_or_part.send(part))
    elsif mail_or_part.respond_to?(:join)
      email_matching(matcher, part, mail_or_part.join(', '))
    elsif mail_or_part.respond_to?(:=~) # Can we match a regex against it?
      mail_or_part =~ Regexp.new(Regexp.escape(matcher))
    else
      raise UnexpectedMailType, "Cannot match #{matcher} for #{part}"
    end
  end

end

RSpec::Matchers.define :have_from do |from|
  include EmailMatcherHelpers
  match do |container|
    email_matching(from, :from, container)
  end
end
RSpec::Matchers.define :have_to do |to|
  include EmailMatcherHelpers
  match do |container|
    email_matching(to, :to, container)
  end
end
RSpec::Matchers.define :have_cc do |cc|
  include EmailMatcherHelpers
  match do |container|
    email_matching(cc, :cc, container)
  end
end
# The ActionMailer :file delivery method never prints bcc recipients...
# Neither does LetterOpener :(
# But the mail object itself can be tested!
RSpec::Matchers.define :have_bcc do |bcc|
  include EmailMatcherHelpers
  match do |container|
    email_matching(bcc, :bcc, container)
  end
end
RSpec::Matchers.define :have_subject do |subject|
  include EmailMatcherHelpers
  match do |container|
    email_matching(subject, :subject, container)
  end
end

#RSpec::Matchers.define :have_to_username do |to|
#  include EmailMatcherHelpers
#  match do |container|
#    email_matching(to, :, container)
#  end
#end
