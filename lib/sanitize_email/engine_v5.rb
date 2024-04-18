# frozen_string_literal: true

# Copyright (c) 2008 - 2018, 2020, 2022, 2024 Peter H. Boling of RailsBling.com
# Released under the MIT license

module SanitizeEmail
  # For Rails >= 3.1, < 6.0
  # TODO: Remove when support for Rails < 6 is dropped
  class EngineV5 < ::Rails::Engine
    config.to_prepare do
      ActionMailer::Base.register_interceptor(SanitizeEmail::Bleach)
    end
  end
end
