# sanitize_email [![Gem Version](https://badge.fury.io/rb/sanitize_email.png)](http://badge.fury.io/rb/sanitize_email)  [![Build Status](https://secure.travis-ci.org/pboling/sanitize_email.png?branch=master)](https://travis-ci.org/pboling/sanitize_email) [![Code Climate](https://codeclimate.com/github/pboling/sanitize_email.png)](https://codeclimate.com/github/pboling/sanitize_email) [![Coverage Status](https://coveralls.io/repos/pboling/sanitize_email/badge.png)](https://coveralls.io/r/pboling/sanitize_email) [![Dependency Status](https://gemnasium.com/pboling/sanitize_email.png)](https://gemnasium.com/pboling/sanitize_email) [![Endorse Me](http://api.coderwall.com/pboling/endorsecount.png)](http://api.coderwall.com/pboling/endorsecount.png)

This gem allows you to override your mail delivery settings, globally or in a local context.  It's particularly helpful when you want to prevent the delivery of email (e.g. in development/test environments) or alter the to/cc/bcc (e.g. in staging or demo environments) of all email generated from your application.

* compatible with Rails >= 3.X (since v1.0.5)
* compatible with any Ruby app with a Mail handler that uses the `register_interceptor` API (a la ActionMailer and Mail gems)
* configure it and forget it
* little configuration required
* solves common problems in ruby web applications that use email
* provides test helpers and spec matchers to assist with testing email content delivery

## Summary

| Project                 |  Sanitize Email   |
|------------------------ | ----------------- |
| gem name                |  sanitize_email   |
| license                 |  MIT              |
| version                 |  [![Gem Version](https://badge.fury.io/rb/sanitize_email.png)](http://badge.fury.io/rb/sanitize_email) |
| dependencies            |  [![Dependency Status](https://gemnasium.com/pboling/sanitize_email.png)](https://gemnasium.com/pboling/sanitize_email) |
| code quality            |  [![Code Climate](https://codeclimate.com/github/pboling/sanitize_email.png)](https://codeclimate.com/github/pboling/sanitize_email) |
| continuous integration  |  [![Build Status](https://secure.travis-ci.org/pboling/sanitize_email.png?branch=master)](https://travis-ci.org/pboling/sanitize_email) |
| homepage                |  [https://github.com/pboling/sanitize_email][homepage] |
| documentation           |  [http://rdoc.info/github/pboling/sanitize_email/frames][documentation] |
| author                  |  [Peter Boling](https://coderbits.com/pboling) [![Endorse Me](http://api.coderwall.com/pboling/endorsecount.png)](http://api.coderwall.com/pboling/endorsecount.png) |


## Working Locally with Production Data

1. Have a production site with live data
2. Dump the live data and securely transfer it to another machine (e.g. rync -e ssh)
3. Import it into a development database
4. Test features which send out email (registration/signup, order placement, etc.)
5. Emails get sent (in real-life!) but to sanitized email recipients
6. Verify what they look like when sent
7. Iterate on email content design
8. No risk of emailing production addresses

## Re-routing Email on a Staging or QA Server

Another very important use case for me is to transparently re-route email generated from a staging or QA server to an appropriate person.  For example, it's common for us to set up a staging server for a client to use to view our progress and test out new features.  It's important for any email that is generated from our web application be delivered to the client's inbox so that they can review the content and ensure that it's acceptable.  Similarly, we set up QA instances for our own QA team and we use {rails-caddy}[http://github.com/jtrupiano/rails-caddy] to allow each QA person to configure it specifically for them.

## Testing Email from a Hot Production Server

If you install this gem on a production server (which I don't always do), you can load up script/console and override the to/cc/bcc on all emails for the duration of your console session.  This allows you to poke and prod a live production instance, and route all email to your own inbox for inspection.  The best part is that this can all be accomplished without changing a single line of your application code.

## Install Like a Boss

In Gemfile:

  gem 'flag_shih_tzu'

Then:

  $ bundle install


## Setup With An Axe

Create an initializer, if you are using rails, or otherwise configure:

```
SanitizeEmail::Config.configure do |config|
  config[:sanitized_to] =         'to@sanitize_email.org'
  config[:sanitized_cc] =         'cc@sanitize_email.org'
  config[:sanitized_bcc] =        'bcc@sanitize_email.org'
  # run/call whatever logic should turn sanitize_email on and off in this Proc:
  config[:activation_proc] =      Proc.new { %w(development test).include?(Rails.env) }
  config[:use_actual_email_prepended_to_subject] = true         # or false
  config[:use_actual_environment_prepended_to_subject] = true   # or false
  config[:use_actual_email_as_sanitized_user_name] = true       # or false
end
```

Keep in mind, this is ruby (and possibly rails), so you can add conditionals or utilize different environment.rb files to customize these settings on a per-environment basis.

But wait there's more:

Let's say you have a method in your model that you can call to test the signup email. You want to be able to test sending it to any user at any time... but you don't want the user to ACTUALLY get the email, even in production. A dilemma, yes?  Not anymore!

To override the environment based switch use `force_sanitize`, which is normally `nil`, and ignored by default. When set to `true` or `false` it will turn sanitization on or off:

```
  SanitizeEmail.force_sanitize = true
```

There are also two methods that take a block and turn SanitizeEmail on or off:

Regardless of the Config settings of SanitizeEmail you can do a local override to force unsanitary email in any environment.

```
  SanitizeEmail.unsanitary do
    Mail.deliver do
      from      'from@example.org'
      to        'to@example.org' # Will actually be sent to the specified address, not sanitized
      reply_to  'reply_to@example.org'
      subject   'subject'
    end
  end
```

Regardless of the Config settings of SanitizeEmail you can do a local override to send sanitary email in any environment.
You have access to all the same configuration options in the parameter hash as you can set in the actual
SanitizeEmail.configure block.

```
  SanitizeEmail.sanitary({:sanitized_to => 'boo@example.com'}) do # these config options are merged with the globals
    Mail.deliver do
      from      'from@example.org'
      to        'to@example.org' # Will actually be sent to the override addresses, in this case: boo@example.com
      reply_to  'reply_to@example.org'
      subject   'subject'
    end
  end
```

## Deprecations

Sometimes things get deprecated (meaning they still work, but are noisy about it).  If this happens to you, and you like your head in the sand, call this number:

```
  SanitizeEmail::Deprecation.deprecate_in_silence = true
```

## Authors

Peter Boling is the original author of the code, and current maintainer of both the rails 2 and rails 3 development tracks.
John Trupiano did the initial gemification and some refactoring.

## Contributors

See the [Network View](https://github.com/pboling/sanitize_email/network) and the [CHANGELOG](https://github.com/pboling/sanitize_email/blob/master/CHANGELOG.md)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
6. Create new Pull Request

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver].
Violations of this scheme should be reported as bugs. Specifically,
if a minor or patch version is released that breaks backward
compatibility, a new version should be immediately released that
restores compatibility. Breaking changes to the public API will
only be introduced with new major versions.

As a result of this policy, you can (and should) specify a
dependency on this gem using the [Pessimistic Version Constraint][pvc] with two digits of precision.

For example:

    spec.add_dependency 'sanitize_email', '~> 1.0.8'

## References

* [Source Code](http://github.com/pboling/sanitize_email)
* [Gem Release Announcement](http://blog.smartlogicsolutions.com/2009/04/25/reintroducing-sanitize_email-work-with-production-email-without-fear/)
* [Peter's Original Writeup](http://galtzo.blogspot.com/2008/11/sanitize-email-never-worry-about.html)
* [Using sanitize_email to Preview HTML Emails Locally](http://blog.smartlogicsolutions.com/2009/04/30/using-sanitize-email-to-preview-html-emails-locally/)

## Legal

* MIT License - See LICENSE file in this project
* Copyright (c) 2008-2013 [Peter H. Boling][peterboling] of [Rails Bling][railsbling]
* Copyright (c) 2009 [John Trupiano](http://smartlogicsolutions.com/wiki/John_Trupiano) of [SmartLogic Solutions, LLC](http://www.smartlogicsolutions.com)

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74
[railsbling]: http://www.railsbling.com
[peterboling]: http://www.peterboling.com
[documentation]: http://rdoc.info/github/pboling/sanitize_email/frames
[homepage]: https://github.com/pboling/sanitize_email
