# I use this to make life easier when installing and testing from source:
rm -rf sanitize_email-*.gem && gem build sanitize_email.gemspec && sudo gem uninstall sanitize_email && sudo gem install sanitize_email-1.0.0.gem --no-ri --no-rdoc
