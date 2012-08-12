require 'sanitize_email/test_helpers'

module SanitizeEmail
  module RspecMatchers
    include SanitizeEmail::TestHelpers
    [:from, :to, :cc, :bcc, :subject, :reply_to].each do |attribute|
      RSpec::Matchers.define "have_#{attribute}" do |matcher|
        match do |actual|
          email_matching(matcher, attribute, actual)
        end
      end
    end

    [:from, :to, :cc, :bcc, :subject, :reply_to].each do |attribute|
      RSpec::Matchers.define "be_#{attribute}" do |matcher|
        match do |actual|
          string_matching(matcher, attribute, actual)
        end
      end
    end

    RSpec::Matchers.define "have_to_username" do |matcher|
      def get_username(email_message)
        email_message.header.fields[3].value
      end
      match do |actual|
        string_matching(matcher, :to_username, get_username(actual))
      end
    end
  end
end
