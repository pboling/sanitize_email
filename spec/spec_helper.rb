# frozen_string_literal: true

# Copyright (c) 2008 - 2018, 2020, 2022, 2024 Peter H. Boling of RailsBling.com
# Released under the MIT license

require "rails"
require "action_mailer"
require "logger"
require "rspec/pending_for"

puts "Rails version is #{Rails.version}"
puts "BUNDLE_GEMFILE: #{ENV["BUNDLE_GEMFILE"]}"
puts "RAILS_MAJOR_MINOR: #{ENV["RAILS_MAJOR_MINOR"]}"

# RSpec Configs
require "config/byebug"
require "config/rspec/rspec_block_is_expected"
require "config/rspec/rspec_core"
require "config/rspec/version_gem"
require "support/matchers"

# Last thing before loading this gem is to setup code coverage
begin
  # This does not require "simplecov", but
  require "kettle-soup-cover"
  #   this next line has a side-effect of running `.simplecov`
  require "simplecov" if defined?(Kettle::Soup::Cover) && Kettle::Soup::Cover::DO_COV
rescue LoadError
  nil
end

require "sanitize_email"
