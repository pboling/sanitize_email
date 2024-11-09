# frozen_string_literal: true

#### IMPORTANT #######################################################
# Gemfile is for local development ONLY; Gemfile is NOT loaded in CI #
####################################################### IMPORTANT ####

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "combustion", "~> 1.5"

# Specify your gem's dependencies in sanitize_email.gemspec
gemspec

platform :mri do
  # Debugging
  gem "byebug", ">= 11"
end

gem "actionmailer", "~> 7.2.2"
gem "railties", "~> 7.2.2"

# Coverage
gem "kettle-soup-cover", "~> 1.0", ">= 1.0.4"

# Linting
gem "rubocop-lts", "~> 10.1", ">= 10.1.1" # Linting for Ruby >= 2.3
gem "rubocop-packaging", "~> 0.5", ">= 0.5.2"
gem "rubocop-rspec", "~> 2.31"

# Quality
gem "reek", "~> 6.3"

# Documentation
gem "yard", "~> 0.9", ">= 0.9.37"
gem "yard-junk", "~> 0.0"
