
# frozen_string_literal: true

require File.expand_path('lib/sanitize_email/version', __dir__)

Gem::Specification.new do |spec|
  spec.name = 'sanitize_email'
  spec.version = SanitizeEmail::VERSION

  spec.authors = ['Peter Boling', 'John Trupiano', 'George Anderson']
  spec.summary = 'Email Condom for your Ruby Server'
  spec.description = <<~DESCRIPTION
      Email Condom for your Ruby Server.
    In Rails, Sinatra, et al, or simply the mail gem: Aids in development, testing, qa, and production troubleshooting of email issues without worrying that emails will get sent to actual live addresses.
DESCRIPTION
  spec.email = ['peter.boling@gmail.com']

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
  spec.executables   = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.homepage = 'http://github.com/pboling/sanitize_email'
  spec.licenses = ['MIT']
  spec.require_paths = ['lib']
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.3.0'

  # Runtime Dependencies
  # A project wanting to use this gem's engine/railtie will be expected to have already loaded the rails/railtie gem.
  # s.add_dependency "railties", ">= 3.2"
  # to replace the cattr_accessor method we lost when removing rails from run time dependencies
  # s.add_runtime_dependency("facets", ["> 0"])
  spec.add_dependency('mail', ['>= 0'])

  # Development Dependencies
  spec.add_development_dependency('actionmailer', ['>= 3'])
  spec.add_development_dependency('appraisal', '~> 2')
  spec.add_development_dependency('rails', ['>= 3.0', '<= 8'])
  spec.add_development_dependency('rake', ['>= 12'])
  spec.add_development_dependency('rdoc', ['>= 3.12'])
  spec.add_development_dependency('rspec', ['>= 3'])
  spec.add_development_dependency('rspec-block_is_expected', ['~> 1.0', '>= 1.0.5'])
end
