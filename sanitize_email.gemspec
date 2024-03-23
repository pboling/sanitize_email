# frozen_string_literal: true

# Get the GEMFILE_VERSION without *require* "my_gem/version", for code coverage accuracy
# See: https://github.com/simplecov-ruby/simplecov/issues/557#issuecomment-825171399
load "lib/sanitize_email/version.rb"
gem_version = SanitizeEmail::Version::VERSION
SanitizeEmail::Version.send(:remove_const, :VERSION)

Gem::Specification.new do |spec|
  spec.name = "sanitize_email"
  spec.version = gem_version

  # See CONTRIBUTING.md
  spec.cert_chain = ["certs/pboling.pem"]
  spec.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $PROGRAM_NAME.end_with?("gem")

  spec.authors = ["Peter Boling", "John Trupiano", "George Anderson"]
  spec.summary = "Email Condom for your Ruby Server"
  spec.description = <<~DESCRIPTION
      Email Condom for your Ruby Server.
    In Rails, Sinatra, et al, or simply the mail gem: Aids in development, testing, qa, and production troubleshooting of email issues without worrying that emails will get sent to actual live addresses.
  DESCRIPTION
  spec.email = ["peter.boling@gmail.com"]

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir[
    "lib/**/*.rb",
    "CODE_OF_CONDUCT.md",
    "CHANGELOG.md",
    "CONTRIBUTING.md",
    "LICENSE.txt",
    "README.md",
    "SECURITY.md"
  ]
  spec.executables = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.homepage = "http://github.com/pboling/sanitize_email"
  spec.licenses = ["MIT"]
  spec.require_paths = ["lib"]
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 2.3.0"

  # Runtime Dependencies
  # A project wanting to use this gem's engine/railtie will be expected to have already loaded the rails/railtie gem.
  # s.add_dependency "railties", ">= 3.2"
  # to replace the cattr_accessor method we lost when removing rails from run time dependencies
  # s.add_runtime_dependency("facets", ["> 0"])
  spec.add_dependency("mail", "~> 2.0")
  spec.add_dependency("version_gem", "~> 1.1", ">= 1.1.4")

  # Development Dependencies
  spec.add_development_dependency("actionmailer", ">= 3")
  spec.add_development_dependency("appraisal", "~> 2")
  spec.add_development_dependency("rails", ">= 3.0", "<= 8")
  spec.add_development_dependency("rake", ">= 12")
  spec.add_development_dependency("rdoc", ">= 3.12")
  spec.add_development_dependency("rspec", ">= 3")
  spec.add_development_dependency("rspec-block_is_expected", "~> 1.0", ">= 1.0.5")
end
