module SanitizeEmail
  module MailHeaderTools

    def self.prepend_subject_array(message)
      prepend = []
      prepend << SanitizeEmail::MailHeaderTools.prepend_email_to_subject(Array(message.to)) if SanitizeEmail.use_actual_email_prepended_to_subject
      prepend << SanitizeEmail::MailHeaderTools.prepend_environment_to_subject if SanitizeEmail.use_actual_environment_prepended_to_subject
      prepend
    end

    def self.prepend_environment_to_subject
      "[#{Rails.env}]" if defined?(Rails) && Rails.env.present?
    end

    def self.prepend_email_to_subject(actual_addresses)
      "(#{actual_addresses.uniq.join(',').gsub(/@/, ' at ').gsub(/[<>]/, '~')})" if actual_addresses.respond_to?(:join)
    end

    def self.add_original_addresses_as_headers(message)
      ## Add headers by string concat. Setting hash values on message.headers does nothing, strangely. http://goo.gl/v46GY
      {
        'X-Sanitize-Email-To' => Array(message.to).uniq, # can be an array, so casting it as an array
        'X-Sanitize-Email-Cc' => Array(message.cc).uniq  # can be an array, so casting it as an array
        # Don't write out the BCC, as those addresses should not be visible in message headers for obvious reasons
      }.each { |k, v|
        # For each type of address line
        SanitizeEmail::MailHeaderTools.update_header(k, v, message)
      }
    end

    def self.prepend_custom_subject(message)
      message.subject.insert(0, SanitizeEmail::MailHeaderTools.prepend_subject_array(message).join(' ') + ' ')
    end

    # According to https://github.com/mikel/mail this is the correct way to update headers.
    def self.update_header(k, v, message)
      # For each address, as v can be an array of addresses
      Array(v).each_with_index { |a, index|
        num = index + 1
        header_key = num > 1 ?
          "#{k}-#{index+1}" :
          k
        #puts "for #{num}: #{header_key}"
        message.header[header_key] = a.to_s
        # Old way
        # Add headers by string concat. Setting hash values on message.headers does nothing, strangely. http://goo.gl/v46GY
        #message.header = message.header.to_s.strip + "\n#{k}: #{a}"
      } if v
      #puts "\nafter message.header:\n #{message.header}\n"
    end

  end
end
