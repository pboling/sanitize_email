# frozen_string_literal: true

# Copyright (c) 2008 - 2018, 2020, 2022, 2024 Peter H. Boling of RailsBling.com
# Released under the MIT license

require "rails"
require "action_mailer"
require "logger"

# This does not require "simplecov",
#   because that has a side-effect of running `.simplecov`
require "kettle-soup-cover"

# RSpec Configs
require "config/byebug"
require "config/rspec/rspec_block_is_expected"
require "config/rspec/rspec_core"
require "config/rspec/version_gem"
require "support/matchers"

# Last thing before this gem is code coverage:
require "simplecov" if Kettle::Soup::Cover::DO_COV

require "sanitize_email"
