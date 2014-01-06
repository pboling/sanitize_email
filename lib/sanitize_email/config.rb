# Copyright (c) 2008-13 Peter H. Boling of RailsBling.com
# Released under the MIT license

module SanitizeEmail
  class Config

    extend SanitizeEmail::Deprecation

    class << self
      attr_accessor :config
    end

    DEFAULTS = {
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

      :environment => defined?(Rails) && Rails.env.present? ? ('[' << Rails.env << ']') : '[UNKNOWN ENVIRONMENT]',

      # Use the 'real' email address as the username for the sanitized email address
      # e.g. "real@example.com <sanitized@example.com>"
      :use_actual_email_as_sanitized_user_name => false,

      # Prepend the 'real' email address onto the Subject line of the message
      # e.g. "real@example.com rest of subject"
      :use_actual_email_prepended_to_subject => false,

      # Prepend the Rails environment onto the Subject line of the message
      # e.g. "[development] rest of subject"
      :use_actual_environment_prepended_to_subject => false,

      :activation_proc => Proc.new { false }
    }

    @config ||= DEFAULTS
    def self.configure &block
      yield @config

      # Gracefully handle deprecated config values.
      # Actual deprecation warnings are thrown in the top SanitizeEmail module thanks to our use of dynamic methods.
      if @config[:local_environments] && defined?(Rails)
        @config[:activation_proc] = Proc.new { SanitizeEmail.local_environments.include?(Rails.env) }
      end
      if @config[:sanitized_recipients]
        SanitizeEmail.sanitized_recipients # calling it to trigger the deprecation warning.
                                           #Won't actually be set with any value,
                                           # because we are still inside the configure block.
        @config[:sanitized_to] = @config[:sanitized_recipients]
      end
      if !@config[:force_sanitize].nil?
        replacement = "
  Please use SanitizeEmail.force_sanitize or SanitizeEmail.sanitary instead.
  Refer to https://github.com/pboling/sanitize_email/wiki for examples."
        deprecation("SanitizeEmail::Config.config[:force_sanitize]", replacement)
        SanitizeEmail.force_sanitize = @config[:force_sanitize]
      end
    end

  end
end
