#Copyright (c) 2008-12 Peter H. Boling of 9thBit LLC
#Released under the MIT license
# For Rails >= 3.1
module SanitizeEmail
  class Engine < ::Rails::Engine

    config.to_prepare do
      ActionMailer::Base.register_interceptor(SanitizeEmail::Bleach.new)
    end

  end
end
