#Copyright (c) 2008-12 Peter H. Boling of 9thBit LLC
#Released under the MIT license

module SanitizeEmail
  require 'sanitize_email/version'
  require 'sanitize_email/deprecation'
  require 'sanitize_email/config'
  require 'sanitize_email/mail_header_tools'
  require 'sanitize_email/overridden_addresses'
  require 'sanitize_email/bleach'

  class MissingBlockParameter < StandardError; end

  # Allow non-rails implementations to use this gem
  if defined?(::Rails)
    if defined?(::Rails::Engine)
      require 'sanitize_email/engine'
    elsif ::Rails::VERSION::MAJOR == 3 && ::Rails::VERSION::MINOR == 0
      require 'sanitize_email/railtie'
    else
      raise "Please use the 0.X.X versions of sanitize_email for Rails 2.X and below."
    end
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

  def self.activate?(message)
    proc = SanitizeEmail[:activation_proc]
    proc.call(message) if proc.respond_to?(:call)
  end

  class << self
    attr_accessor :force_sanitize
  end
  @force_sanitize = nil

  # Regardless of the Config settings of SanitizeEmail you can do a local override to send sanitary email in any environment.
  # You have access to all the same configuration options in the parameter hash as you can set in the actual
  # SanitizeEmail.configure block.
  #
  # SanitizeEmail.sanitary({:sanitized_to => 'boo@example.com'}) do # these config options are merged with the globals
  #   Mail.deliver do
  #     from      'from@example.org'
  #     to        'to@example.org' # Will actually be sent to the override addresses, in this case: boo@example.com
  #     reply_to  'reply_to@example.org'
  #     subject   'subject'
  #   end
  # end
  #
  def self.sanitary(config_options = {}, &block)
    raise MissingBlockParameter, "SanitizeEmail.sanitary must be called with a block" unless block_given?
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
    raise MissingBlockParameter, "SanitizeEmail.unsanitary must be called with a block" unless block_given?
    janitor({:forcing => false}) do
      yield
    end
  end

  def self.janitor(options, &block)
    raise MissingBlockParameter, "SanitizeEmail.janitor must be called with a block" unless block_given?
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
