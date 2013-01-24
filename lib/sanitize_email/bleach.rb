#Copyright (c) 2008-12 Peter H. Boling of 9thBit LLC
#Released under the MIT license

module SanitizeEmail
  class Bleach

    class MissingTo < StandardError;
    end
    class UnknownOverride < StandardError;
    end

    # Can override global configs at the instance level.
    attr_accessor :engage, # Turn sanitization on or off just for this instance
                  :sanitized_to, :sanitized_cc, :sanitized_bcc, # Replace non-white-listed addresses with these sanitized addresses.
                  :good_list, # White-listed addresses will not be molested as to, cc, or bcc
                  :bad_list, # Black-listed addresses will be removed from to, cc and bcc when sanitization is engaged
                  :injected # Track whether or not the subject has been injected with usernames

    def initialize(args = {})
      # Not using extract_options! because non-rails compatibility is a goal
      @sanitized_to = args[:sanitized_to] || SanitizeEmail[:sanitized_to]
      @sanitized_cc = args[:sanitized_cc] || SanitizeEmail[:sanitized_cc]
      @sanitized_bcc = args[:sanitized_bcc] || SanitizeEmail[:sanitized_bcc]
      @good_list = args[:good_list] || SanitizeEmail[:good_list] || []
      @bad_list = args[:bad_list] || SanitizeEmail[:bad_list] || []
      @engage = args[:engage] || SanitizeEmail[:engage]
      @injected = false
    end

    # If all recipient addresses are white-listed the field is left alone.
    def delivering_email(message)
      if self.sanitize_engaged?(message)
        # Cache the correct addresses. These will get overwritten when the
        cache_to = self.to_override(message.to)
        cache_cc = self.cc_override(message.cc)
        cache_bcc = self.bcc_override(message.bcc)

        add_original_addresses_as_headers(message)

        message.subject = self.prepend_email_to_subject(message.subject, message.to) if SanitizeEmail.use_actual_email_prepended_to_subject
        message.subject = self.prepend_environment_to_subject(message.subject) if SanitizeEmail.use_actual_environment_prepended_to_subject

        message.to = cache_to
        message.cc = cache_cc
        message.bcc = cache_bcc
      end
    end

    def add_original_addresses_as_headers(message)
        ## Add headers by string concat. Setting hash values on message.headers does nothing, strangely. http://goo.gl/v46GY
        {
            'X-Sanitize-Email-To' => message.to,
            'X-Sanitize-Email-Cc' => message.cc
            # Don't write out the BCC, as those addresses should not be visible in message headers for obvious reasons
        }.each { |k, v|
          # For each type of address line
          v.each { |a|
            # For each address
            message.header = message.header.to_s + "\n#{k}: #{a}"
          } if v
        }
    end

    def activate?(message)
      SanitizeEmail.activation_proc.call(message) if SanitizeEmail.activation_proc.respond_to?(:call)
    end

    # This method will be called by the Hook to determine if an override should occur
    # There are three ways SanitizeEmail can be turned on; in order of precedence they are:
    #
    # 1. SanitizeEmail.force_sanitize = true # by default it is nil
    # 2. Mail.register_interceptor(SanitizeEmail::Bleach.new(:engage => true)) # by default it is nil
    # 3. SanitizeEmail::Config.configure {|config| config[:activation_proc] = Proc.new { true } } be default it is false
    #
    # Note: Number 1 is the method used by the SanitizeEmail.sanitary block
    # Note: Number 2 would not be used unless you setup your own register_interceptor)
    # If installed but not configured, sanitize email DOES NOTHING.  Until configured the defaults leave it turned off.
    def sanitize_engaged?(message)

      # Has it been forced via the force_sanitize mattr?
      forced = SanitizeEmail.force_sanitize
      return forced unless forced.nil?

      # Is this particular instance of Bleach engaged
      engaged = self.engage
      return engaged unless engaged.nil?

      # Should we sanitize due to the activation_proc?
      return self.activate?(message)

    end

    def prepend_email_to_subject(real_subject, actual_addresses)
      if !actual_addresses.respond_to?(:join)
        real_subject
      else
        "(#{actual_addresses.join(',').gsub(/@/, ' at ').gsub(/[<>]/, '~')}) #{real_subject}"
      end
    end

    def prepend_environment_to_subject(real_subject)
      if Rails.env.present?
        "[#{Rails.env?}] #{real_subject}"
      end
    end

    def to_override(actual_addresses)
      to = override_email(:to, actual_addresses)
      raise MissingTo, 'after overriding :to there are no addresses to send in To: header.' if to.empty?
      to.join(',')
    end

    def cc_override(actual_addresses)
      override_email(:cc, actual_addresses).join(',')
    end

    def bcc_override(actual_addresses)
      override_email(:bcc, actual_addresses).join(',')
    end

    #######
    protected
    #######

    def address_list_filter(list_type, address)
      # TODO: How does this handle email addresses with user names like "Foo Example <foo@example.org>"
      has_address = self.send(list_type).include?(address)
      case list_type
        when :good_list then
          has_address ? address : nil
        when :bad_list then
          has_address ? nil : address
      end
    end

    def inject_user_names(real_addresses, sanitized_addresses)
      real_addresses.inject([]) do |result, real_recipient|
        if real_recipient.nil?
          new_recipient = sanitized_addresses
        else
          new_recipient = sanitized_addresses.map { |sanitized| "#{real_recipient.gsub(/@/, ' at ').gsub(/[<>]/, '~')} <#{sanitized}>" }
        end
        result << new_recipient
        result
      end.flatten
    end

    def clean_addresses(addresses, list_type)
      # Normalize addresses just in case it isn't an array yet
      addresses.map { |address|
        # If this address is on the good list then let it pass
        self.address_list_filter(list_type, address)
      }.compact
    end

    def sanitize_addresses(type)
      case type
        when :to then
          Array(self.sanitized_to)
        when :cc then
          Array(self.sanitized_cc)
        when :bcc then
          Array(self.sanitized_bcc)
        else
          raise UnknownOverride, "unknown email override"
      end
    end

    # Allow good listed email addresses, and then remove the bad listed addresses
    def good_listize(real_addresses)
      good_listed = self.clean_addresses(real_addresses, :good_list)
      good_listed = self.clean_addresses(good_listed, :bad_list) unless good_listed.empty?
      good_listed
    end

    def override_email(type, actual_addresses)
      # Normalized to an arrays
      #puts "override_email 1: #{type} - #{actual_addresses}"
      real_addresses = Array(actual_addresses)

#puts "override_email 2: #{type} - #{real_addresses}"
# If there were no original recipients, then we DO NOT override the nil with the sanitized recipients
      return [] if real_addresses.empty?

      good_listed = good_listize(real_addresses)
#puts "override_email 3: #{type} - #{good_listed}"
# If there are good_list addresses to send to then use them as is, no mods needed
      return good_listed unless good_listed.empty?

      # TODO: Allow overriding if an addressed email is on the good list?
      # If there are no sanitized addresses we can't override!
      sanitized_addresses = sanitize_addresses(type)
      #puts "override_email 3: #{type} - #{sanitized_addresses}"
      return [] if sanitized_addresses.empty?

      # At this point it is assured that the address list will need to be sanitized
      # One more check to ensure none of the configured sanitized email addresses are on the bad_list
      sanitized_addresses = self.clean_addresses(sanitized_addresses, :bad_list)
      #puts "override_email 4: #{type} - #{sanitized_addresses}"

      # If we don't want to inject the 'email' in the 'user name' section of the sanitized recipients,
      # then just return the default sanitized recipients
      return sanitized_addresses unless SanitizeEmail.use_actual_email_as_sanitized_user_name

      with_user_names = self.inject_user_names(real_addresses, sanitized_addresses)
      #puts "real_addresses 2: #{real_addresses}"
      #puts "override_email 5: #{type} - #{with_user_names}"
      # Otherwise inject the email as the 'user name'
      return with_user_names
    end

  end # end Class Bleach
end # end Module SanitizeEmail


