#Copyright (c) 2008-12 Peter H. Boling of 9thBit LLC
#Released under the MIT license
require 'rails'
require 'action_mailer'

module SanitizeEmail
  if defined?(Rails) && ::Rails::VERSION::MAJOR >= 3
    require 'sanitize_email/version'
    require 'sanitize_email/config'
    require 'sanitize_email/sanitizer'
    require 'sanitize_email/hook'

    if ::Rails::VERSION::MINOR >= 1
      require 'sanitize_email/engine'
    elsif ::Rails::VERSION::MINOR == 0
      require 'sanitize_email/railtie'
    end
  else
    raise "Please use the 0.X.X versions of sanitize_email for Rails 2.X and below."
  end

  def self.[](key)
    return nil unless key.respond_to?(:to_sym)
    SanitizeEmail::Config.config[key.to_sym]
  end

  def self.method_missing(name, *args)
    SanitizeEmail[name]
  end

end
