# Copyright (c) 2008-16 Peter H. Boling of RailsBling.com
# Released under the MIT license
require 'sanitize_email/test_helpers'
require 'sanitize_email/mail_ext'

module SanitizeEmail
  # Provides matchers that can be used in Rspec tests to assert the behavior of email
  module RspecMatchers
    include SanitizeEmail::TestHelpers
    [:from, :to, :cc, :bcc, :reply_to].each do |attribute|
      RSpec::Matchers.define "have_#{attribute}" do |matcher|
        match do |actual|
          email_matching(matcher, attribute, actual)
        end
      end
    end

    [:subject].each do |attribute|
      RSpec::Matchers.define "have_#{attribute}" do |matcher|
        match do |actual|
          string_matching_attribute(matcher, attribute, actual)
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

    # Cribbed from email_spec gem
    RSpec::Matchers.define "have_body_text" do |matcher|
      match do |actual|
        # Normalize all the whitespace, to improve match fuzz
        if matcher.is_a?(String)
          actual_text =  actual.default_part_body.to_s.gsub(/\s+/, " ")
          matcher_text = matcher.gsub(/\s+/, " ")
          raise SanitizeEmail::TestHelpers::UnexpectedMailType, "Cannot find #{matcher} in body" unless actual_text.respond_to?(:include?)
          actual_text.include?(matcher_text)
        else
          actual_text =  actual.default_part_body.to_s
          raise SanitizeEmail::TestHelpers::UnexpectedMailType, "Cannot find #{matcher} in body" unless actual_text.respond_to?(:=~)
          !!(actual_text =~ matcher)
        end
      end
    end

    # Cribbed from email_spec gem
    RSpec::Matchers.define "have_header" do |name, matcher|
      match do |actual|
        header = actual.header
        if matcher.is_a?(String)
          header[name].to_s == matcher
        else
          header[name].to_s =~ matcher
        end
      end
    end

  end
end
