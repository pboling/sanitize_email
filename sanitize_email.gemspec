# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sanitize_email}
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.extra_rdoc_files = ["README.rdoc"]
  s.version = "0.3.0"
  s.authors = ["Peter Boling", "John Trupiano", "George Anderson"]
  s.date = %q{2009-06-09}
  s.description = %q{allows you to play with your application's email abilities without worrying that emails will get sent to actual live addresses}
  s.email = ['peter.boling@gmail.com', 'jtrupiano@gmail.com', 'george@benevolentcode.com']
  # s.files = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*', 'test/**/*'].to_a
  s.files = ["lib/sanitize_email/custom_environments.rb", "lib/sanitize_email/sanitize_email.rb", "lib/sanitize_email.rb", "MIT-LICENSE", "Rakefile", "README.rdoc", "VERSION.yml", "test/sample_mailer.rb", "test/sanitize_email_test.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/pboling/sanitize_email}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{johntrupiano}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Tool to aid in development, testing, qa, and production troubleshooting of email issues without worrying that emails will get sent to actual live addresses.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
