require 'spec_helper'

describe SanitizeEmail do

  SanitizeEmail::Config.configure do |config|
    config[:sanitized_recipients] = 'to@sanitize_email.org'
    config[:sanitized_bcc] =        'bcc@sanitize_email.org'
    config[:sanitized_cc] =         'cc@sanitize_email.org'
    config[:local_environments] =   []
    config[:use_actual_email_prepended_to_subject] = true
    config[:use_actual_email_as_sanitized_user_name] = true
  end

  def sanitize_mail_delivery(sanitization_switch = false)
    # Ensure that localish? will returns sanitization_switch
    SanitizeEmail::Config.config[:force_sanitize] = sanitization_switch
    Launchy.should_receive(:open)
    mail = Mail.deliver do
      from      'from@example.org'
      to        'to@example.org'
      cc        'cc@example.org'
      reply_to  'reply_to@example.org'
      subject   'original subject'
    end
  end

  before(:each) do
    Launchy.stub(:open)
    location = File.expand_path('../tmp/mail_dump', __FILE__)
    FileUtils.rm_rf(location)
    Mail.defaults do
      delivery_method LetterOpener::DeliveryMethod, :location => location
    end
    Mail.register_interceptor(SanitizeEmail::Hook)
    @location = location
  end

  context "localish? is false" do
    it "alters nothing" do
      sanitize_mail_delivery(false)
      # All the email gets dumped to file once for each type of recipient (:to, :cc, :bcc)
      # Each file is identical, so we only need to check one of them:
      email = File.read(Dir["#{@location}/*/plain.html"].first)
      email.should have_from("from@example.org")
      email.should have_to("to@example.org")
      # Letter Opener won't let us test the cc
      #email.should have_cc("cc@example.org")
      # Letter Opener won't let us test the bcc
      #email.should have_bcc("cc@example.org")
      email.should have_subject("original subject")
    end
  end

  context "localish? is true" do
    it "should override" do
      sanitize_mail_delivery(true)
      # All the email gets dumped to file once for each type of recipient (:to, :cc, :bcc)
      # Each file is identical, so we only need to check one of them:
      email = File.read(Dir["#{@location}/*/plain.html"].first)
      email.should have_from("from@example.org")
      # Letter Opener won't let us test the to when the to has a 'user name'
      #email.should have_to("~to at example.org~ <to@sanitize_email.org>")
      # Letter Opener won't let us test the bcc
      #email.should have_cc("cc@sanitize_email.org")
      email.should have_subject("(to at example.org) original subject")
    end
  end
end
