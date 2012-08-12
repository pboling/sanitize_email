#Copyright (c) 2008-12 Peter H. Boling of 9thBit LLC
#Released under the MIT license

module SanitizeEmail
  require 'sanitize_email/version'
  require 'sanitize_email/deprecation'
  require 'sanitize_email/config'
  require 'sanitize_email/bleach'

  # Allow non-rails implementations to use this gem
  if defined?(Rails) && ::Rails::VERSION::MAJOR >= 3
    if ::Rails::VERSION::MINOR >= 1
      require 'sanitize_email/engine'
    elsif ::Rails::VERSION::MINOR == 0
      require 'sanitize_email/railtie'
    end
  elsif defined?(Rails)
    raise "Please use the 0.X.X versions of sanitize_email for Rails 2.X and below."
  elsif defined?(Mailer) && Mailer.respond_to?(:register_interceptor)
    Mailer.register_interceptor(SanitizeEmail::Bleach.new)
  end

  def self.[](key)
    return nil unless key.respond_to?(:to_sym)
    SanitizeEmail::Config.config[key.to_sym]
  end

  def self.method_missing(name, *args)
    SanitizeEmail[name]
  end

  # NOTE: Deprecated method
  # We have to actually define because we can't deprecate methods that are hooked up via method_missing
  def self.sanitized_recipients
    SanitizeEmail[:sanitized_recipients]
  end

  # NOTE: Deprecated method
  # We have to actually define because we can't deprecate methods that are hooked up via method_missing
  def self.local_environments
    SanitizeEmail[:local_environments]
  end

  mattr_reader :force_sanitize
  mattr_writer :force_sanitize
  self.force_sanitize = nil

  # Regardless of the Config settings of SanitizeEmail you can do a local override to send sanitary email in any environment.
  # You have access to all the same configuration options in the parameter hash as you can set in the actual
  # SanitizeEmail.configure block.
  #
  # SanitizeEmail.sanitary(config_options = {}) do
  #   Mail.deliver do
  #     from      'from@example.org'
  #     to        'to@example.org' # Will actually be sent to the override addresses setup in Config
  #     reply_to  'reply_to@example.org'
  #     subject   'subject'
  #   end
  # end
  #
  def self.sanitary(config_options = {}, &block)
    janitor({:forcing => true}) do
      original = SanitizeEmail::Config.config.dup
      SanitizeEmail::Config.config.merge!(config_options)
      yield
      SanitizeEmail::Config.config = original
    end
  end

  # Regardless of the Config settings of SanitizeEmail you can do a local override to force unsanitary email in any environment.
  #
  # SanitizeEmail.unsanitary do
  #   Mail.deliver do
  #     from      'from@example.org'
  #     to        'to@example.org'
  #     reply_to  'reply_to@example.org'
  #     subject   'subject'
  #   end
  # end
  #
  def self.unsanitary &block
    janitor({:forcing => false}) do
      yield
    end
  end

  def self.janitor(options, &block)
    return false unless block_given?
    original = SanitizeEmail.force_sanitize
    SanitizeEmail.force_sanitize = options[:forcing]
    yield
    SanitizeEmail.force_sanitize = original
  end

  # Setup Deprecations!
  class << self
    extend SanitizeEmail::Deprecation
    deprecated_alias :sanitized_recipients, :sanitized_to
    deprecated :local_environments, :activation_proc
  end

end
