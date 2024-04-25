# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "combustion", "~> 1.4"

# Specify your gem's dependencies in sanitize_email.gemspec
gemspec

# Appraisals is having a *rough* time upgrading to Ruby 3, and worse upgrading past bundler v2.3.
# Changes in Bundler 2.4 and/or 2.5 are causing many issues, and that's why we use git,
# as some of the issues are fixed there.
# See - https://github.com/thoughtbot/appraisal/issues/214
# See - https://github.com/thoughtbot/appraisal/issues/218
gem "appraisal", "~> 2", github: "thoughtbot/appraisal"

platform :mri do
  # Debugging
  gem "byebug", ">= 11"
end

gem "actionmailer", "~> 7.1.3.2"
gem "railties", "~> 7.1.3.2"
gem "actionpack", "~> 7.1.3.2"
gem "rspec-rails", "~> 6.0" # For Rails 6.1 & Rails 7.0 - 7.1

# Coverage
gem "kettle-soup-cover", "~> 1.0", ">= 1.0.2"

# Linting
gem "rubocop-lts", "~> 10.1", ">= 10.1.1" # Linting for Ruby >= 2.3
gem "rubocop-packaging", "~> 0.5", ">= 0.5.2"
gem "rubocop-rspec", "~> 2.10"

# Quality
gem "reek", "~> 6.3"
