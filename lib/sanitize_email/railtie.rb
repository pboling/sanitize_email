#Copyright (c) 2008-12 Peter H. Boling of 9thBit LLC
#Released under the MIT license
# For Rails 3.0, which didn't yet support Engines'
module SanitizeEmail
  class Railtie < ::Rails::Railtie

    config.before_configuration do
      ActionMailer::Base.register_interceptor(SanitizeEmail::Bleach.new)
    end

  end
end
