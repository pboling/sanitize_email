
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
  s.extra_rdoc_files = [
    'CHANGELOG.md',
    'LICENSE',
    'README.md',
  ]
  s.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
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

  # Development Dependencies
  s.add_development_dependency('actionmailer', ['>= 3'])
  s.add_development_dependency('appraisal', '~> 1')
  s.add_development_dependency('bundler', '~> 1')
  s.add_development_dependency('gem-release', '~> 2')
  s.add_development_dependency('coveralls', '~> 0')
  s.add_development_dependency('mail', ['>= 0'])
  s.add_development_dependency('rails', ['>= 3.0', '<= 7.0.5.1'])
  s.add_development_dependency('rake', ['>= 12'])
  s.add_development_dependency('rdoc', ['>= 3.12'])
  s.add_development_dependency('rspec', ['>= 3'])
  s.add_development_dependency('wwtd', '~> 1')
end
