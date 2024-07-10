require "version_gem/ruby"

if VersionGem::Ruby.gte_minimum_version?("4.1")
  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  Rails.application.configure do
    config.action_mailer.delivery_method = :test
  end
end
