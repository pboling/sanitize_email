# frozen_string_literal: true

# NOTE(2024-04-24): Current release of rake v13 supports Ruby >= 2.3
# NOTE(2024-04-24): Current release of json v2 supports Ruby >= 2.3

appraise "rails-3-0" do
  gem "rails", "~> 3.0.0"
  gem "reek", "~> 2.0" # for Ruby < 2.0
  gem "tins", "~> 1.6.0" # for Ruby < 2.0
  gem "json", "~> 1.8.3"
  gem "rake", "~> 10.0"
  gem "rest-client", "~> 1.8.0"
end
appraise "rails-3-1" do
  gem "actionmailer", "~> 3.1.0"
  gem "railties", "~> 3.1.0"
  gem "reek", "~> 2.0" # for Ruby < 2.0
  gem "tins", "~> 1.6.0" # for Ruby < 2.0
  gem "json", "~> 1.8.3"
  gem "rake", "~> 10.0"
  gem "rest-client", "~> 1.8.0"
end
appraise "rails-3-2" do
  gem "actionmailer", "~> 3.2.0"
  gem "railties", "~> 3.2.0"
  # reek >= 4.0 requires Ruby 2.1 minimum
  gem "reek", "~>3.11.0"
  gem "json", "~> 1.8.3"
  gem "rake", "~> 10.0"
end

# Compat: Ruby >= 1.9.3
# Test Matrix:
#   - Ruby 2.3
appraise "rails-4-0" do
  # Load order is very important with combustion!
  gem "combustion", "~> 1.4"

  gem "actionmailer", "~> 4.0.13"
  gem "railties", "~> 4.0.13"
  #   gem "actionpack", "~> 4.0.13"
  gem "rdoc", "6.1.2.1"
  gem "json", ">= 1.7.7", "~> 1.7"
  #   gem "rspec-rails", "~> 3.0" # For Rails 4
end

# Compat: Ruby >= 1.9.3
# Test Matrix:
#   - Ruby 2.3
appraise "rails-4-1" do
  # Load order is very important with combustion!
  gem "combustion", "~> 1.4"

  gem "actionmailer", "~> 4.1.16"
  gem "railties", "~> 4.1.16"
  #   gem "actionpack", "~> 4.1.16"
  gem "rdoc", "6.1.2.1"
  gem "json", ">= 1.7.7", "~> 1.7"
  #   gem "rspec-rails", "~> 3.0" # For Rails 4
end

# Compat: Ruby >= 1.9.3
# Test Matrix:
#   - Ruby 2.3
#   - Ruby 2.4
appraise "rails-4-2" do
  # Load order is very important with combustion!
  gem "combustion", "~> 1.4"

  gem "actionmailer", "~> 4.2.11.3"
  gem "railties", "~> 4.2.11.3"
  #   gem "actionpack", "~> 4.2.11.3"
  gem "rdoc", "6.1.2.1"
  gem "nokogiri"
  #   gem "rspec-rails", "~> 3.0" # For Rails 4
end

# Compat: Ruby >= 2.2.2
# Test Matrix:
#   - Ruby 2.3
#   - Ruby 2.4
appraise "rails-5-0" do
  # Load order is very important with combustion!
  gem "combustion", "~> 1.4"

  gem "actionmailer", "~> 5.0.7.2"
  gem "railties", "~> 5.0.7.2"
  #   gem "actionpack", "~> 5.0.7.2"
  gem "nokogiri"
  #   gem "rspec-rails", "~> 4.0" # For Rails 5.0 & 5.1
end

# Compat: Ruby >= 2.2.2
# Test Matrix:
#   - Ruby 2.3
#   - Ruby 2.4
#   - Ruby 2.5
appraise "rails-5-1" do
  # Load order is very important with combustion!
  gem "combustion", "~> 1.4"

  gem "actionmailer", "~> 5.1.7"
  gem "railties", "~> 5.1.7"
  #   gem "actionpack", "~> 5.1.7"
  gem "nokogiri"
  #   gem "rspec-rails", "~> 4.0" # For Rails 5.0 & 5.1
end

# Compat: Ruby >= 2.2.2
# Test Matrix:
#   - Ruby 2.3
#   - Ruby 2.4
#   - Ruby 2.5
#   - Ruby 2.6
#   - Ruby 2.7
appraise "rails-5-2" do
  # Load order is very important with combustion!
  gem "combustion", "~> 1.4"

  gem "actionmailer", "~> 5.2.8.1"
  gem "railties", "~> 5.2.8.1"
  #   gem "actionpack", "~> 5.2.8.1"
  gem "nokogiri"
  #   gem "rspec-rails", "~> 5.0" # For Rails 5.2 & Rails 6.0
end

# Compat: Ruby >= 2.5
# Test Matrix:
#   - Ruby 2.5
#   - Ruby 2.6
#   - Ruby 2.7
appraise "rails-6-0" do
  # Load order is very important with combustion!
  gem "combustion", "~> 1.4"

  gem "actionmailer", "~> 6.0.6.1"
  gem "railties", "~> 6.0.6.1"
  #   gem "actionpack", "~> 6.0.6.1"
  #   gem "rspec-rails", "~> 5.0" # For Rails 5.2 & Rails 6.0
end

# Compat: Ruby >= 2.5
# Test Matrix:
#   - Ruby 2.5
#   - Ruby 2.6
#   - Ruby 2.7
#   - Ruby 3.0
appraise "rails-6-1" do
  # Load order is very important with combustion!
  gem "combustion", "~> 1.4"

  gem "actionmailer", "~> 6.1.7.7"
  gem "railties", "~> 6.1.7.7"
  #   gem "actionpack", "~> 6.1.7.7"
  #   gem "rspec-rails", "~> 6.0" # For Rails 6.1 & Rails 7.0 - 7.1
end

# Compat: Ruby >= 2.7
# Test Matrix:
#   - Ruby 2.7
#   - Ruby 3.0
#   - Ruby 3.1
appraise "rails-7-0" do
  # Load order is very important with combustion!
  gem "combustion", "~> 1.4"

  gem "actionmailer", "~> 7.0.8.1"
  gem "railties", "~> 7.0.8.1"
  #   gem "actionpack", "~> 7.0.8.1"
  #   gem "rspec-rails", "~> 6.0" # For Rails 6.1 & Rails 7.0 - 7.1
end

# Compat: Ruby >= 2.7
# Test Matrix:
#   - Ruby 2.7
#   - Ruby 3.0
#   - Ruby 3.1
#   - Ruby 3.2
appraise "rails-7-1" do
  # Load order is very important with combustion!
  gem "combustion", "~> 1.4"

  gem "actionmailer", "~> 7.1.3.2"
  gem "railties", "~> 7.1.3.2"
  #   gem "actionpack", "~> 7.1.3.2"
  #   gem "rspec-rails", "~> 6.0" # For Rails 6.1 & Rails 7.0 - 7.1
end
