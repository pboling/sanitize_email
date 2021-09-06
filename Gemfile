# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

group :test do
  # Travis-CI does not support C-extensions on JRuby
  ruby_version = Gem::Version.new(RUBY_VERSION)
  if ruby_version >= Gem::Version.new('2.1')
    gem 'rubocop', '~> 0.59.2', platforms: :mri
    gem 'rubocop-rspec', '~> 1.29.1', platforms: :mri
  end
  if ruby_version >= Gem::Version.new('2.0')
    gem 'byebug', platforms: :mri
    gem 'pry', platforms: :mri
    gem 'pry-byebug', platforms: :mri
  end
end

# Specify your gem's dependencies in sanitize_email.gemspec
gemspec
