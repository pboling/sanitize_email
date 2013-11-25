# Copyright (c) 2008-13 Peter H. Boling of RailsBling.com
# Released under the MIT license
# For Rails 3.0, which didn't yet support Engines
module SanitizeEmail
  class Railtie < ::Rails::Railtie

    config.after_initialize do
      ActionMailer::Base.register_interceptor(SanitizeEmail::Bleach.new)
    end

  end
end
