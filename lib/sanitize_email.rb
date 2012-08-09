#Copyright (c) 2008-12 Peter H. Boling of 9thBit LLC
#Released under the MIT license

module SanitizeEmail
  require 'sanitize_email/version'
  require 'sanitize_email/config'
  require 'sanitize_email/bleach'
  require 'sanitize_email/deprecation'

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

  def self.sanitized_recipients
    SanitizeEmail[:sanitized_recipients]
  end

  def self.local_environments
    SanitizeEmail[:local_environments]
  end

  #
  #
  #
  def force_sanitize &block
    janitor({:forcing => true}) do
      yield
    end
  end

  def unsanitary &block
    janitor({:forcing => false}) do
      yield
    end
  end

  class << self
    extend SanitizeEmail::Deprecation
    deprecated_alias :sanitized_recipients, :sanitized_to
    deprecated :local_environments, :local_environment_proc
  end

  private
  def janitor(options, &block)
    return false unless block_given?
    original = SanitizeEmail[:force_sanitize]
    SanitizeEmail[:force_sanitize] = options[:forcing]
    yield
    SanitizeEmail[:force_sanitize] = original
  end

end
