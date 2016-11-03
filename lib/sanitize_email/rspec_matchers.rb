# Copyright (c) 2008-16 Peter H. Boling of RailsBling.com
# Released under the MIT license
# Note: the RspecMatchers are composed matchers:
# See: http://www.relishapp.com/rspec/rspec-expectations/v/3-5/docs/composing-matchers

require "sanitize_email/mail_ext"

module SanitizeEmail
  # Provides matchers that can be used in Rspec tests to assert the behavior of email
  module RspecMatchers
    [:from, :to, :cc, :bcc, :subject, :reply_to].each do |attribute|
      RSpec::Matchers.define "have_#{attribute}" do |matcher|
        match do |actual|
          @actual = actual.send(attribute)
          @actual = @actual.join(", ") if @actual.respond_to?(:join)
          expect(@actual).to match(matcher)
        end
      end
    end

    [:from, :to, :cc, :bcc, :subject, :reply_to].each do |attribute|
      RSpec::Matchers.define "match_#{attribute}" do |matcher|
        match do |actual|
          @actual = actual.send(attribute)
          @actual = @actual.join(", ") if @actual.respond_to?(:join)
          expect(@actual).to match(matcher)
        end
      end
    end

    [:from, :to, :cc, :bcc, :subject, :reply_to].each do |attribute|
      RSpec::Matchers.define "be_#{attribute}" do |matcher|
        match do |actual|
          @actual = actual.send(attribute)
          @actual = @actual.join(", ") if @actual.respond_to?(:join)
          expect(@actual).to be(matcher)
        end
      end
    end

    RSpec::Matchers.define "have_to_username" do |matcher|
      def get_to_username(email_message)
        username_header = email_message.header["X-Sanitize-Email-To"]
        return username_header unless username_header.is_a?(Mail::Field)
        email_message.header.fields[3].value
      end
      match do |actual|
        @actual = get_to_username(actual)
        expect(@actual).to match(matcher), "expected email to have X-Sanitize-Email-To header matching #{matcher.inspect}, got #{@actual.inspect}"
      end
    end

    RSpec::Matchers.define "have_cc_username" do |matcher|
      def get_cc_username(email_message)
        username_header = email_message.header["X-Sanitize-Email-Cc"]
        return username_header unless username_header.is_a?(Mail::Field)
        email_message.header.fields[3].value
      end
      match do |actual|
        @actual = get_cc_username(actual)
        expect(@actual).to match(matcher), "expected email to have X-Sanitize-Email-Cc header matching #{matcher.inspect}, got #{@actual.inspect}"
      end
    end

    # Cribbed from email_spec gem
    RSpec::Matchers.define "have_body_text" do |matcher|
      def get_fuzzy_body(email_message)
        email_message.default_part_body.to_s.gsub(/\s+/, " ")
      end

      def get_fuzzy_matcher(to_fuzz)
        to_fuzz.gsub(/\s+/, " ")
      end
      match do |actual|
        @actual = get_fuzzy_body(actual)
        fuzzy_matcher = get_fuzzy_matcher(matcher)
        expect(@actual).to match(fuzzy_matcher), "expected email body match #{matcher.inspect}, got #{@actual.inspect}"
      end
    end

    # Cribbed from email_spec gem
    RSpec::Matchers.define "have_header" do |name, matcher|
      match do |actual|
        @actual = actual.header[name]
        @actual = @actual.value unless @actual.nil?
        expect(@actual).to match(matcher), "expected email to have header #{name} matching #{matcher.inspect}, got #{@actual.inspect}"
      end
    end

  end
end
