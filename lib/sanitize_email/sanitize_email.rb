#Copyright (c) 2008 Peter H. Boling of 9thBit LLC
#Released under the MIT license

module NinthBit
  module SanitizeEmail

    def self.included(base)
  
      # Adds the following class attributes to the classes that include NinthBit::SanitizeEmail
      base.cattr_accessor :force_sanitize
      base.force_sanitize = nil
      
      # Specify the BCC addresses for the messages that go out in 'local' environments
      base.cattr_accessor :sanitized_bcc
      base.sanitized_bcc = nil
     
      # Specify the CC addresses for the messages that go out in 'local' environments
      base.cattr_accessor :sanitized_cc
      base.sanitized_cc = nil
    
      # The recipient addresses for the messages, either as a string (for a single
      # address) or an array (for multiple addresses) that go out in 'local' environments
      base.cattr_accessor :sanitized_recipients
      base.sanitized_recipients = nil
      
      # Use the 'real' email address as the username for the sanitized email address
      # e.g. "real@email.com <sanitized@email.com>"
      base.cattr_accessor :use_actual_email_as_sanitized_user_name
      base.use_actual_email_as_sanitized_user_name = false
      
      base.class_eval do
        # We need to alias these methods so that our new methods get used instead
        alias :real_bcc :bcc
        alias :real_cc :cc
        alias :real_recipients :recipients

        def localish?
          # consider_local is a method in sanitize_email/lib/custom_environments.rb
          # it is included in ActionMailer in sanitize_email/init.rb
          !self.class.force_sanitize.nil? ? self.class.force_sanitize : self.class.consider_local?
        end

        def recipients(*addresses)
          real_recipients *addresses
          puts "sanitize_email error: sanitized_recipients is not set" if self.class.sanitized_recipients.nil?
          localish? ? override(:recipients) : real_recipients
        end
        
        def cc(*addresses)
          real_cc *addresses
          localish? ? override(:cc) : real_cc
        end

        def bcc(*addresses)
          real_bcc *addresses
          localish? ? override(:bcc) : real_bcc
        end
        
        #######
        private
        #######

        def override(type)
          real_addresses, sanitized_addresses = 
            case type
            when :recipients
              [real_recipients, self.class.sanitized_recipients]
            when :cc
              [real_cc, self.class.sanitized_cc]
            when :bcc
              [real_bcc, self.class.sanitized_bcc]
            else raise "sanitize_email error: unknown email override"
            end
          
          return sanitized_addresses if sanitized_addresses.nil? || !self.class.use_actual_email_as_sanitized_user_name

          out = real_addresses.inject([]) do |result, real_recipient|
            result << sanitized_addresses.map{|sanitized| "#{real_recipient} <#{sanitized}>"}
            result
          end.flatten
          return out
        end
        
      end
    end
  end # end Module SanitizeEmail
end # end Module NinthBit
