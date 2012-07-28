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
      :sanitized_recipients => nil,

      # Use the 'real' email address as the username for the sanitized email address
      # e.g. "real@example.com <sanitized@example.com>"
      :use_actual_email_as_sanitized_user_name => false,

      # Prepend the 'real' email address onto the Subject line of the message
      # e.g. "real@example.com rest of subject"
      :use_actual_email_prepended_to_subject => false,

      :local_environments => %w( development test )
    }

    def self.configure &block
      yield self.config
    end

  end
end
