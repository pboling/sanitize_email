# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sanitize_email/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "sanitize_email"
  s.version = SanitizeEmail::VERSION

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter Boling", "John Trupiano", "George Anderson"]
  s.date = "2012-08-08"
  s.summary = "In Rails, Sinatra, or any framework using a Mail-like API: Test an application's email abilities without ever sending a message to actual live addresses"
  s.description = "In Rails, Sinatra, or any framework using a Mail-like API: Aids in development, testing, qa, and production troubleshooting of email issues without worrying that emails will get sent to actual live addresses."
  s.email = ["peter.boling@gmail.com", "jtrupiano@gmail.com", "george@benevolentcode.com"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.homepage = "http://github.com/pboling/sanitize_email"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<facets>, ["> 0"]) # to replace the cattr_accessor method we lost when removing rails
      s.add_development_dependency(%q<rails>, ["> 3"])
      s.add_development_dependency(%q<actionmailer>, ["> 3"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<letter_opener>, [">= 0"])
      s.add_development_dependency(%q<launchy>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<mail>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 3.12"])
      s.add_development_dependency(%q<reek>, [">= 1.2.8"])
      s.add_development_dependency(%q<roodi>, [">= 2.1.0"])
    else
      s.add_dependency(%q<facets>, ["> 0"]) # to replace the cattr_accessor method we lost when removing rails
      s.add_dependency(%q<rails>, ["> 3"])
      s.add_dependency(%q<actionmailer>, ["> 3"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<letter_opener>, [">= 0"])
      s.add_dependency(%q<launchy>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<mail>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 3.12"])
      s.add_dependency(%q<reek>, [">= 1.2.8"])
      s.add_dependency(%q<roodi>, [">= 2.1.0"])
    end
  else
    s.add_dependency(%q<facets>, ["> 0"]) # to replace the cattr_accessor method we lost when removing rails
    s.add_dependency(%q<rails>, ["> 3"])
    s.add_dependency(%q<actionmailer>, ["> 3"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<letter_opener>, [">= 0"])
    s.add_dependency(%q<launchy>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<mail>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 3.12"])
    s.add_dependency(%q<reek>, [">= 1.2.8"])
    s.add_dependency(%q<roodi>, [">= 2.1.0"])
  end
end

