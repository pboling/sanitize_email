# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sanitize_email/version'

Gem::Specification.new do |spec|
  spec.name          = "sanitize_email"
  spec.version       = SanitizeEmail::VERSION
  spec.authors       = ["Peter Boling", "John Trupiano", "George Anderson"]
  spec.email         = ["peter.boling@gmail.com", "jtrupiano@gmail.com", "george@benevolentcode.com"]
  spec.summary       = %q{Test an application's email abilities without ever sending a message to actual live addresses}
  spec.description   = %q{Test an application's email abilities without ever sending a message to actual live addresses}
  spec.homepage      = "http://github.com/pboling/sanitize_email"
  spec.license       = "MIT"
  spec.rdoc_options = ["--charset=UTF-8"]

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency(%q<actionmailer>, [">= 0",'<= 3.1'])

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
