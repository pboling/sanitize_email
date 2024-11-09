# frozen_string_literal: true

# Copyright (c) 2008 - 2018, 2020, 2022, 2024 Peter H. Boling of RailsBling.com
# Released under the MIT license
# Note: the RspecMatchers are composed matchers:
# See: http://www.relishapp.com/rspec/rspec-expectations/v/3-5/docs/composing-matchers

require_relative "mail_ext"

module SanitizeEmail
  # Provides matchers that can be used in
  #   Rspec tests to assert the behavior of email
  module RspecMatchers
    %i[from to cc bcc subject reply_to].each do |attribute|
      RSpec::Matchers.define("have_#{attribute}") do |matcher|
        match do |actual|
          @actual = actual.send(attribute)
          @actual = @actual.join(", ") if @actual.respond_to?(:join)
          expect(@actual).to(match(matcher))
        end
      end
    end

    %i[from to cc bcc subject reply_to].each do |attribute|
      RSpec::Matchers.define("match_#{attribute}") do |matcher|
        match do |actual|
          @actual = actual.send(attribute)
          @actual = @actual.join(", ") if @actual.respond_to?(:join)
          expect(@actual).to(match(matcher))
        end
      end
    end

    %i[from to cc bcc subject reply_to].each do |attribute|
      RSpec::Matchers.define("be_#{attribute}") do |matcher|
        match do |actual|
          @actual = actual.send(attribute)
          @actual = @actual.join(", ") if @actual.respond_to?(:join)
          expect(@actual).to(be(matcher))
        end
      end
    end

    RSpec::Matchers.define("have_to_username") do |matcher|
      def get_to_usernames(email_message)
        to_addrs = email_message[:to].addrs
        to_addrs.map(&:name)
      end
      match do |actual|
        @actual = get_to_usernames(actual)
        expect(@actual).to(include(match(matcher)))
      end
    end

    RSpec::Matchers.define("have_sanitized_to_header") do |matcher|
      def get_sanitized_to_header(email_message)
        sanitized_to_header = email_message.header["X-Sanitize-Email-To"]
        return sanitized_to_header.value if sanitized_to_header.is_a?(Mail::Field)

        "no header found at 'X-Sanitize-Email-To'"
      end
      match do |actual|
        @actual = get_sanitized_to_header(actual)
        expect(@actual).to(match(matcher))
      end
    end

    RSpec::Matchers.define("have_cc_username") do |matcher|
      def get_cc_usernames(email_message)
        to_addrs = email_message[:cc].addrs
        to_addrs.map(&:name)
      end
      match do |actual|
        @actual = get_cc_usernames(actual)
        expect(@actual).to(include(match(matcher)))
      end
    end

    RSpec::Matchers.define("have_sanitized_cc_header") do |matcher|
      def get_sanitized_cc_header(email_message)
        sanitized_cc_header = email_message.header["X-Sanitize-Email-Cc"]
        return sanitized_cc_header.value if sanitized_cc_header.is_a?(Mail::Field)

        "no header found at 'X-Sanitize-Email-Cc'"
      end
      match do |actual|
        @actual = get_sanitized_cc_header(actual)
        expect(@actual).to(match(matcher))
      end
    end

    RSpec::Matchers.define("have_bcc_username") do |matcher|
      def get_bcc_usernames(email_message)
        to_addrs = email_message[:bcc].addrs
        to_addrs.map(&:name)
      end
      match do |actual|
        @actual = get_bcc_usernames(actual)
        expect(@actual).to(include(match(matcher)))
      end
    end

    # Cribbed from email_spec gem
    RSpec::Matchers.define("have_body_text") do |matcher|
      def get_fuzzy_body(email_message)
        email_message.default_part_body.to_s.gsub(/\s+/, " ")
      end

      def get_fuzzy_matcher(to_fuzz)
        to_fuzz.gsub(/\s+/, " ")
      end
      match do |actual|
        @actual = get_fuzzy_body(actual)
        fuzzy_matcher = get_fuzzy_matcher(matcher)
        expect(@actual).to(match(fuzzy_matcher))
      end
    end

    # Cribbed from email_spec gem
    RSpec::Matchers.define("have_header") do |name, matcher|
      match do |actual|
        @actual = actual.header[name]
        @actual = @actual.value unless @actual.nil?
        expect(@actual).to(match(matcher))
      end
    end
  end
end
