#Copyright (c) 2008-12 Peter H. Boling of 9thBit LLC
#Released under the MIT license
module SanitizeEmail
  module Sanitizer
    def self.included(base)
      base.extend SanitizeEmail::Sanitizer::ClassMethods
    end

    module ClassMethods

      def subject_override(real_subject, actual_addresses)
        if actual_addresses.nil? || !SanitizeEmail.use_actual_email_prepended_to_subject
          real_subject
        else
          "(#{actual_addresses.join(',').gsub(/@/,' at ').gsub(/[<>]/,'~')}) #{real_subject}"
        end
      end

      def recipients_override(actual_addresses)
        override_email(:recipients, actual_addresses)
      end

      def cc_override(actual_addresses)
        override_email(:cc, actual_addresses)
      end

      def bcc_override(actual_addresses)
        override_email(:bcc, actual_addresses)
      end

      #######
      private
      #######

      def override_email(type, actual_addresses)
        real_addresses, sanitized_addresses = case type
          when :recipients
            [actual_addresses, SanitizeEmail.sanitized_recipients]
          when :cc
            [actual_addresses, SanitizeEmail.sanitized_cc]
          when :bcc
            [actual_addresses, SanitizeEmail.sanitized_bcc]
          else raise "sanitize_email error: unknown email override"
        end
        # Normalize to an array
        real_addresses = [real_addresses] unless real_addresses.is_a?(Array)
        # Normalize to an array
        sanitized_addresses = [sanitized_addresses] unless sanitized_addresses.is_a?(Array)

        # If there were no original recipients, then we DO NOT override the nil with the sanitized recipients
        return nil if real_addresses.blank?
        # If there are no sanitized addresses we can't override!
        return nil if sanitized_addresses.blank?
        # If we don't want to inject the actual email in the 'user name' section of the sanitized recipients,
        # then just return the default sanitized recipients
        return sanitized_addresses unless SanitizeEmail.use_actual_email_as_sanitized_user_name

        out = real_addresses.inject([]) do |result, real_recipient|
          if real_recipient.nil?
            new_recipient = sanitized_addresses
          else
            new_recipient = sanitized_addresses.map{|sanitized| "#{real_recipient.gsub(/@/,' at ').gsub(/[<>]/,'~')} <#{sanitized}>"}
          end
          result << new_recipient
          result
        end.flatten
        return out
      end

    end

  end
end
