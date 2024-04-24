# frozen_string_literal: true

# Copyright (c) 2008 - 2018, 2020, 2022, 2024 Peter H. Boling of RailsBling.com
# Released under the MIT license

module SanitizeEmail
  # For Rails >= 6.0
  class EngineV6 < ::Rails::Engine
    config.to_prepare do |app|
      # For the reasoning behind the difference between v5 and v6 engines,
      #   - see: https://github.com/rails/rails/issues/36546#issuecomment-850888284
      Rails.application.config.action_mailer.register_interceptor(SanitizeEmail::Bleach)
    end
  end
end
