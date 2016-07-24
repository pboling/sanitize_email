# Copyright (c) 2008-16 Peter H. Boling of RailsBling.com
# Released under the MIT license

module SanitizeEmail
  # For Rails >= 3.1
  class Engine < ::Rails::Engine

    config.to_prepare do
      ActionMailer::Base.register_interceptor(SanitizeEmail::Bleach)
    end

  end
end
