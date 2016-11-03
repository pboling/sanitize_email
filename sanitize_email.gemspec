# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sanitize_email/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "sanitize_email"
  s.version = SanitizeEmail::VERSION

  s.authors = ["Peter Boling", "John Trupiano", "George Anderson"]
  s.summary = "Email Condom for your Ruby Server"
  s.description = <<EOS
  Email Condom for your Ruby Server.
In Rails, Sinatra, et al, or simply the mail gem: Aids in development, testing, qa, and production troubleshooting of email issues without worrying that emails will get sent to actual live addresses.
EOS
  s.email = ["peter.boling@gmail.com"]
  s.extra_rdoc_files = [
    "CHANGELOG.md",
    "LICENSE",
    "README.md"
  ]
  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.homepage = "http://github.com/pboling/sanitize_email"
  s.licenses = ["MIT"]
  s.email = 'peter.boling@gmail.com'
  s.require_paths = ["lib"]
  s.platform = Gem::Platform::RUBY

  # Runtime Dependencies
  # A project wanting to use this gem's engine/railtie will be expected to have already loaded the rails/railtie gem.
  #s.add_dependency "railties", ">= 3.2"
  # to replace the cattr_accessor method we lost when removing rails from run time dependencies
  #s.add_runtime_dependency("facets", ["> 0"])

  # Development Dependencies
  s.add_development_dependency "bundler"
  s.add_development_dependency("rails", [">= 3.0"])
  s.add_development_dependency("actionmailer", [">= 3.0"])
  s.add_development_dependency("letter_opener", [">= 0"])
  s.add_development_dependency("launchy", [">= 0"])
  s.add_development_dependency("rspec", [">= 3"])
  s.add_development_dependency("mail", [">= 0"])
  s.add_development_dependency("rdoc", [">= 3.12"])
  s.add_development_dependency("reek", [">= 1.2.8"])
  s.add_development_dependency("roodi", [">= 2.1.0"])
  s.add_development_dependency("rake", [">= 0"])
  s.add_development_dependency("pry", [">= 0"])
  s.add_development_dependency("appraisal")
  s.add_development_dependency("wwtd")
  s.add_development_dependency("coveralls")
end
