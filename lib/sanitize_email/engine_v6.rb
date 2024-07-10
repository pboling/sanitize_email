# frozen_string_literal: true

# Copyright (c) 2008 - 2018, 2020, 2022, 2024 Peter H. Boling of RailsBling.com
# Released under the MIT license
require "rails/engine"

module SanitizeEmail
  # For Rails >= 6.0
  class EngineV6 < ::Rails::Engine
    # Runs before frameworks, like ActionMailer, are initialized
    config.before_initialize do
      ActiveSupport.on_load(:action_mailer) do
        # Within :action_mailer hook, self is ActionMailer::Base
        register_interceptor(SanitizeEmail::Bleach)
      end
    end
  end
end
