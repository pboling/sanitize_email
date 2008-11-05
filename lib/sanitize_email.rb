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

        def recipients
          puts "santize_email error: sanitized_recipients is nil" if self.class.sanitized_recipients.nil?
          localish? ? self.class.sanitized_recipients : real_recipients
        end
          
        def bcc
          localish? && !self.class.sanitized_bcc.nil? ? self.class.sanitized_bcc : real_bcc
        end
      
        def cc
          localish? && !self.class.sanitized_cc.nil? ? self.class.sanitized_cc : real_cc
        end
      
      end

    end
  end # end Module SanitizeEmail
end # end Module NinthBit
