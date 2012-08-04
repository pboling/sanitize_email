#Copyright (c) 2008-12 Peter H. Boling of 9thBit LLC
#Released under the MIT license
require 'rails'
require 'action_mailer'

module SanitizeEmail
  require 'sanitize_email/version'
  require 'sanitize_email/config'
  require 'sanitize_email/bleach'
  require 'sanitize_email/deprecation'

  # Allow non-rails implementations to use this gem
  if @rails = defined?(Rails) && ::Rails::VERSION::MAJOR >= 3
    if ::Rails::VERSION::MINOR >= 1
      require 'sanitize_email/engine'
    elsif ::Rails::VERSION::MINOR == 0
      require 'sanitize_email/railtie'
    end
  elsif @rails = defined?(Rails)
    raise "Please use the 0.X.X versions of sanitize_email for Rails 2.X and below."
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

  class << self
    extend SanitizeEmail::Deprecation
    deprecated_alias :sanitized_recipients, :sanitized_to
    deprecated :local_environments, :local_environment_proc
  end
end
