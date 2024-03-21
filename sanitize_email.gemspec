
# frozen_string_literal: true

require File.expand_path('lib/sanitize_email/version', __dir__)

Gem::Specification.new do |s|
  s.name = 'sanitize_email'
  s.version = SanitizeEmail::VERSION

  s.authors = ['Peter Boling', 'John Trupiano', 'George Anderson']
  s.summary = 'Email Condom for your Ruby Server'
  s.description = <<~DESCRIPTION
      Email Condom for your Ruby Server.
    In Rails, Sinatra, et al, or simply the mail gem: Aids in development, testing, qa, and production troubleshooting of email issues without worrying that emails will get sent to actual live addresses.
DESCRIPTION
  s.email = ['peter.boling@gmail.com']

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
  s.executables   = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.homepage = 'http://github.com/pboling/sanitize_email'
  s.licenses = ['MIT']
  s.require_paths = ['lib']
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.3.0'

  # Runtime Dependencies
  # A project wanting to use this gem's engine/railtie will be expected to have already loaded the rails/railtie gem.
  # s.add_dependency "railties", ">= 3.2"
  # to replace the cattr_accessor method we lost when removing rails from run time dependencies
  # s.add_runtime_dependency("facets", ["> 0"])
  s.add_dependency('mail', ['>= 0'])

  # Development Dependencies
  s.add_development_dependency('actionmailer', ['>= 3'])
  s.add_development_dependency('appraisal', '~> 2')
  s.add_development_dependency('gem-release', '~> 2')
  s.add_development_dependency('coveralls', '~> 0')
  s.add_development_dependency('rails', ['>= 3.0', '<= 8'])
  s.add_development_dependency('rake', ['>= 12'])
  s.add_development_dependency('rdoc', ['>= 3.12'])
  s.add_development_dependency('rspec', ['>= 3'])
  s.add_development_dependency('wwtd', '~> 1')
end
