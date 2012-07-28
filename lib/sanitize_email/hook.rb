#Copyright (c) 2008-12 Peter H. Boling of 9thBit LLC
#Released under the MIT license

module SanitizeEmail
  class Hook

    include SanitizeEmail::Sanitizer

    def self.delivering_email(message)
      if self.localish?
        message.subject = self.subject_override(message.subject, message.to)
        message.to = self.recipients_override(message.to)
        message.cc = self.cc_override(message.cc)
        message.bcc = self.bcc_override(message.bcc)
      end
    end

    def self.consider_local?
      SanitizeEmail.local_environments.include?(Rails.env) if defined?(Rails)
    end

    # This method will be called by the Hook to determine if an override should occur
    def self.localish?
      !SanitizeEmail.force_sanitize.nil? ? SanitizeEmail.force_sanitize : self.consider_local?
    end

  end # end Class Hook
end # end Module SanitizeEmail


