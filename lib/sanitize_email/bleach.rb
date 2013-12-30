# Copyright (c) 2008-13 Peter H. Boling of RailsBling.com
# Released under the MIT license

module SanitizeEmail
  # SanitizeEmail::Bleach determines whether to sanitize the headers of an email, and does so when appropriate.
  class Bleach

    # Can override global configs at the instance level.
    attr_accessor :engage, # Turn sanitization on or off just for this instance
                  :overridden_addresses

    def initialize(args = {})
      # Not using extract_options! because non-rails compatibility is a goal
      @engage = args[:engage] || SanitizeEmail[:engage]
    end

    # If all recipient addresses are white-listed the field is left alone.
    def delivering_email(message)
      if self.sanitize_engaged?(message)
        SanitizeEmail::MailHeaderTools.add_original_addresses_as_headers(message)
        SanitizeEmail::MailHeaderTools.prepend_custom_subject(message)

        o = SanitizeEmail::OverriddenAddresses.new(message)

        message.to = o.overridden_to
        message.cc = o.overridden_cc
        message.bcc = o.overridden_bcc
      end
    end

    # This method will be called by the Hook to determine if an override should occur
    # There are three ways SanitizeEmail can be turned on; in order of precedence they are:
    #
    # 1. SanitizeEmail.force_sanitize = true # by default it is nil
    # 2. Mail.register_interceptor(SanitizeEmail::Bleach.new(:engage => true)) # by default it is nil
    # 3. SanitizeEmail::Config.configure {|config| config[:activation_proc] = Proc.new { true } } by default it is false
    #
    # Note: Number 1 is the method used by the SanitizeEmail.sanitary block
    # Note: Number 2 would not be used unless you setup your own register_interceptor)
    # If installed but not configured, sanitize email DOES NOTHING.  Until configured the defaults leave it turned off.
    def sanitize_engaged?(message)

      # Don't sanitize the message if it will not be delivered
      return false unless message.perform_deliveries

      # Has it been forced via the force_sanitize mattr?
      forced = SanitizeEmail.force_sanitize
      return forced unless forced.nil?

      # Is this particular instance of Bleach engaged
      engaged = self.engage
      return engaged unless engaged.nil?

      # Should we sanitize due to the activation_proc?
      return SanitizeEmail.activate?(message)

    end

  end # end Class Bleach
end # end Module SanitizeEmail


