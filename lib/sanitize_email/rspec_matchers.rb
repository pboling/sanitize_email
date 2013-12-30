# Copyright (c) 2008-13 Peter H. Boling of RailsBling.com
# Released under the MIT license
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

    # Cribbed from email_spec gem
    RSpec::Matchers.define "have_body_text" do |matcher|
      match do |actual|
        # Normalize all the whitespace, to improve match fuzz
        if matcher.is_a?(String)
          actual_text =  actual.default_part_body.to_s.gsub(/\s+/, " ")
          matcher_text = matcher.gsub(/\s+/, " ")
          unless actual_text.include?(matcher_text)
            raise SanitizeEmail::TestHelpers::UnexpectedMailType, "Cannot find #{matcher} in body"
          end
        else
          actual_text =  actual.default_part_body.to_s
          unless !!(actual_text =~ matcher)
            raise SanitizeEmail::TestHelpers::UnexpectedMailType, "Cannot find #{matcher} in body"
          end
        end
      end
    end

  end
end

# Cribbed from email_spec gem
module EmailSpec::MailExt
  def default_part
    @default_part ||= html_part || text_part || self
  end

  def default_part_body
    default_part.body
  end
end

Mail::Message.send(:include, EmailSpec::MailExt)
