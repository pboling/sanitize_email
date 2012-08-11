module SanitizeEmail
  module EmailMatchers
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
