module SanitizeEmail
  class Config
    cattr_accessor :config
    self.config ||= {
      # Adds the following class attributes to the classes that include NinthBit::SanitizeEmail
      :force_sanitize => nil,

      # Specify the BCC addresses for the messages that go out in 'local' environments
      :sanitized_bcc => nil,

      # Specify the CC addresses for the messages that go out in 'local' environments
      :sanitized_cc => nil,

      # The recipient addresses for the messages, either as a string (for a single
      # address) or an array (for multiple addresses) that go out in 'local' environments
      :sanitized_to => nil,

      # a white list
      :good_list => nil,

      # a black list
      :bad_list => nil,

      # Use the 'real' email address as the username for the sanitized email address
      # e.g. "real@example.com <sanitized@example.com>"
      :use_actual_email_as_sanitized_user_name => false,

      # Prepend the 'real' email address onto the Subject line of the message
      # e.g. "real@example.com rest of subject"
      :use_actual_email_prepended_to_subject => false,

      :local_environment_proc => Proc.new { true }
    }

    def self.configure &block
      yield self.config

      # Gracefully handle deprecated config values.
      # Actual deprecation warnings are thrown in the top SanitizeEmail module thanks to our use of dynamic methods.
      if config[:local_environments] && defined?(Rails)
        config[:local_environment_proc] = Proc.new { SanitizeEmail.local_environments.include?(Rails.env) }
      end
      if config[:sanitize_recipients]
        config[:sanitize_to] = SanitizeEmail.sanitized_recipients
      end
    end

  end
end
