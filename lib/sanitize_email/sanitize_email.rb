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
      
      base.class_eval do
        #We need to alias these methods so that our new methods get used instead
        alias :real_bcc :bcc
        alias :real_cc :cc
        alias :real_recipients :recipients

        def localish?
          #consider_local is a method in sanitize_email/lib/custom_environments.rb
          # it is included in ActionMailer in sanitize_email/init.rb
          !self.class.force_sanitize.nil? ? self.class.force_sanitize : self.class.consider_local?
        end

        def recipients(*addresses)
          if localish? 
            puts "sanitize_email error: sanitized_recipients is not set" if self.class.sanitized_recipients.nil?
            self.class.sanitized_recipients 
          else
            real_recipients(*addresses)
          end
        end

        def bcc(*addresses)
          localish? ? self.class.sanitized_bcc : real_bcc(*addresses)
        end

        def cc(*addresses)
          localish? ? self.class.sanitized_cc : real_cc(*addresses)
        end

      end

    end
  end # end Module SanitizeEmail
end # end Module NinthBit
