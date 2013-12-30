Version 1.1.0 - DEC.30.2013
* Add documentation for non-Rails setup by Peter Boling
* Add documentation for using sanitize_email's bundled Rspec Matchers by Peter Boling
* Add documentation for using sanitize_email's bundled Test Helpers by Peter Boling
* Stopped using method_missing internally for config access by Peter Boling
* Improved ease of setup with mail gem outside rails by auto-configuring the interceptor (default inactive) by Peter Boling

Version 1.0.11 - DEC.30.2013
* Fix travis build by Peter Boling
* Fix test suite to run on Ruby 1.8.7 again, add back to Travis by Peter Boling
* Add mode badges to Readme by Peter Boling
* Improve Readme by Peter Boling

Version 1.0.10 - NOV.24.2013
* Expand test suite to test against all supported versions of ActionMailer and Railties gems by Peter Boling
* Add Coveralls by Peter Boling
* Fix Travis Build by Peter Boling
* Stop using method missing when alternatives exist inside gem by Peter Boling

Version 1.0.9 - AUG.31.2013
* \[Bug Fix\] More Fixes for #12 - Strange repeating headers, and repeated subject injection by Peter Boling

Version 1.0.8 - AUG.30.2013
* \[Bug Fix\] Partial Fix for #12 - Strange repeating headers by Peter Boling
* Lots of refactoring by Peter Boling
  * Properly supports when a to/cc field has multiple recipients sanitized and adds all to mail headers
* Improved specs by Peter Boling

Version 1.0.7 - AUG.06.2013

* \[Bug Fix\] Stripping the message headers before appending new headers.
  - In a scenario where there is a trailing space, adding the newline before we append results in a blank header which throws an error as illegal by Eric Musgrove
* Minor updates to Gemspec by Peter Boling

Version 1.0.6 - JAN.25.2013

* \[New Feature\] use_actual_environment_prepended_to_subject by [altonymous](https://github.com/Altonymous)

Version 1.0.5 - DEC.20.2012

* Fixes Compatibility with Rails 3.0 by David Morton
* Added header tests to ensure original header markers do not appear when sanitize is disabled by Harry Lascelles
* Added tests and email_spec for have_header matcher by Harry Lascelles
* Make activation_proc option a bit more configurable by Nikita Fedyashev
* Adding message to engage proc, so we can sanitize on a message by message basis by Harry Lascelles
* Allowing for nil ccs and bccs by Harry Lascelles
* Adding original emails as headers, except for bcc by Harry Lascelles

Version 1.0.4 - SEP.10.2012

* Removes facets dependency, upgrades to rspec v2.11 by Peter Boling
* REEK refactoring by Peter Boling
* Improve handling of mal-formed calls to (un)sanitary (raises error) by Peter Boling
* code cleanup by Peter Boling
* Put some examples back in the README, until I improve and link to the wiki. :/

Version 1.0.3 - AUG.12.2012

* Accidentally broke spec suite with 1.0.2 - fixed
* Expanded spec suite
* Split test_helpers from rspec_matchers (test_helpers may be useful in TestUnit
* Moving Examples from README to wiki
* Document and implement working deprecation of version 0's SanitizeEmail::Config.config[:force_sanitize] behavior
    * Now use SanitizeEmail.force_sanitize = true # or false or nil

Version 1.0.2 - AUG.11.2012

* Massive improvement to spec suite, and found bleeding
    * needed to unregister the interceptors:
        * Mail.class_variable_get(:@@delivery_interceptors).pop
* Added SanitizeEmail.deprecate_in_silence
* Added SanitizeEmail.sanitary &block
    * Local overrides to SanitizeEmail config for specific local purpose
    * Force Sanitization On for a block
* Added SanitizeEmail.unsanitary &block
    * Force Sanitization Off for a block
* Added SanitizeEmail.force_sanitize = true # or false or nil
    * Force Sanitization On or Off

Version 1.0.1 - Unintentional, unexpected bump behavior from gem-release gem (Issues #24 & #25)

Version 1.0.0.rc3 - AUG.08.2012

* Forgot to switch from jeweler to gem-release, so making appropriate changes and bumping again
* Aligning closer to bundler gem defaults
* Removing Rails dependency - Should work with Sinatra, or any Mail-like interface
* Added facets dependency to get cattr functionality (and hopefully other cool stuff)
* Gem dependencies in gemspec

Version 1.0.0.rc2 - AUG.08.2012 - botched

* Bug: loading the gem in a rails app broke mailer specs in the app - Fixed
    * https://github.com/pboling/sanitize_email/issues/4
* Moved MIT-LICENSE to LICENSE, updated years
* Added Travis-CI for... CI.

Version 1.0.0.rc1

* Added a good_list and a bad_list (whitelist and blacklist)
* Added Deprecation library
* Refactored Sanitization module into Hook class
* Renamed Hook Class to Bleach Class
* Improve support for non-rails implementations
* Deprecated local_environments in favor of local_environment_proc
* Deprecated sanitized_recipients in favor of sanitized_to
* More specs

Version 1.0.0.alpha2

* Complete refactor!  Implementing initial support for Rails >= 3.0 (new ActionMailer API)
    * Support for Rails <= 2.X remains in version 0.X.X releases.
* NinthBit namespace is now SanitizeEmail namespace
* Now has a first class Config class

XXXXXXXXXXXXXXXXXXXXXXX Rail 3.0+ Only Form here on up! XXXXXXXXXXXXXXXXXXXXXXX

Version 0.3.8

* Update specs, note requirement of Rails 2.3 or below to run spec quite.
* Support use_actual_email_prepended_to_subject
* Fix environment check for old versions of Rails
* Improved Readme

Version 0.3.7

* Improved Installation instructions
* Fixed so tests run from inside a rails app (previously only ran standalone)

Version 0.3.6

* Fixed Installation instructions
* Improved README

Old version?

* Fixed require paths
* added about.yml and this CHANGELOG
