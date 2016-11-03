# Copyright (c) 2008-16 Peter H. Boling of RailsBling.com
# Released under the MIT license
# Note: the RspecMatchers no longer use these methods.  Instead they are composed matchers:
# See: http://www.relishapp.com/rspec/rspec-expectations/v/3-5/docs/composing-matchers

module SanitizeEmail
  # Helpers for test-unit
  module TestHelpers

    # Error raised when unable to match an expected part of email in order to fail the test
    class UnexpectedMailType < StandardError; end

    def string_matching_attribute(matcher, part, attribute)
      string_matching(matcher, part, attribute)
    end

    def string_matching(matcher, part, attribute)
      if attribute.respond_to?(:=~) # Can we match a regex against it?
        if matcher.is_a?(Regexp)
          attribute =~ matcher
        else
          attribute =~ Regexp.new(Regexp.escape(matcher))
        end
      else
        raise UnexpectedMailType, "Cannot match #{matcher} for #{part}"
      end
    end

    # Normalize arrays to strings
    def array_matching(matcher, part, attribute)
      attribute = attribute.join(', ') if attribute.respond_to?(:join)
      string_matching(matcher, part, attribute)
    end

    def email_matching(matcher, part, mail_or_part)
      email_attribute_matching(matcher, part, mail_or_part.send(part))
    end

    def email_attribute_matching(matcher, part, attribute)
      array_matching(matcher, part, attribute)
    end

  end
end
