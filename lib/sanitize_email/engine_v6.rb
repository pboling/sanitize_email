# frozen_string_literal: true

# Copyright (c) 2008 - 2018, 2020, 2022, 2024 Peter H. Boling of RailsBling.com
# Released under the MIT license
require "rails/engine"

module SanitizeEmail
  # For Rails >= 6.0
  class EngineV6 < ::Rails::Engine
    config.to_prepare do
      # For the reasoning behind the difference between v5 and v6 engines,
      #   - see: https://github.com/rails/rails/issues/42170#issuecomment-835177539
      Rails.application.config.action_mailer.interceptors = ["SanitizeEmail::Bleach"]
    end
  end
end
