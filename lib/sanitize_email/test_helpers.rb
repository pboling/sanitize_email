# Copyright (c) 2008-13 Peter H. Boling of RailsBling.com
# Released under the MIT license
module SanitizeEmail
  module TestHelpers
    class UnexpectedMailType < StandardError; end

    def string_matching(matcher, part, mail_or_part)
      if mail_or_part.respond_to?(:=~) # Can we match a regex against it?
        mail_or_part =~ Regexp.new(Regexp.escape(matcher))
      else
        raise UnexpectedMailType, "Cannot match #{matcher} for #{part}"
      end
    end

    # Normalize arrays to strings
    def array_matching(matcher, part, mail_or_part)
      mail_or_part = mail_or_part.join(', ') if mail_or_part.respond_to?(:join)
      string_matching(matcher, part, mail_or_part)
    end

    def email_matching(matcher, part, mail_or_part)
      array_matching(matcher, part, mail_or_part.send(part))
    end

  end
end
