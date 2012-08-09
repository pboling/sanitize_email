require 'spec_helper'

#
# TODO: Letter Opener should *not* be required, but setting the delivery method to :file was causing connection errors... WTF?
#
# Letter Opener won't let us test the to when the to has a 'user name'
#   @email_file.should have_to("~to at example.org~ <to@sanitize_email.org>")
# TODO: Also not sure how to test the user name part of the To: header via the mail object
#
# Letter Opener won't let us test the bcc
#   @email_file.should have_cc("cc@sanitize_email.org")
# Fortunately we can still test the mail object returned by the deliver call
#

describe SanitizeEmail do

  after(:each) do
    SanitizeEmail::Config.config = {}
  end

  def sanitize_spec_dryer(rails_env = 'test')
    Launchy.stub(:open)
    location = File.expand_path('../tmp/mail_dump', __FILE__)
    FileUtils.rm_rf(location)
    Mail.defaults do
      delivery_method LetterOpener::DeliveryMethod, :location => location
    end

    Rails.stub(:env).and_return(rails_env)
    @location = location
  end

  def configure_sanitize_email(sanitize_hash = {})
    defaults = {
      :sanitized_to =>  'to@sanitize_email.org',
      :sanitized_cc =>  'cc@sanitize_email.org',
      :sanitized_bcc => 'bcc@sanitize_email.org',
      :use_actual_email_prepended_to_subject => true,
      :use_actual_email_as_sanitized_user_name => true
    }
    sanitize_hash = defaults.merge(sanitize_hash)
    SanitizeEmail::Config.configure do |config|
      config[:sanitized_to] =         sanitize_hash[:sanitized_to]
      config[:sanitized_cc] =         sanitize_hash[:sanitized_cc]
      config[:sanitized_bcc] =        sanitize_hash[:sanitized_bcc]
      config[:use_actual_email_prepended_to_subject] = sanitize_hash[:use_actual_email_prepended_to_subject]
      config[:use_actual_email_as_sanitized_user_name] = sanitize_hash[:use_actual_email_as_sanitized_user_name]
      # For testing deprecated configuration options:
      config[:local_environments] =   sanitize_hash[:local_environments] if sanitize_hash[:local_environments]
      config[:sanitized_to] ||= sanitize_hash[:sanitized_recipients] if sanitize_hash[:sanitized_recipients]
    end
    Mail.register_interceptor(SanitizeEmail::Bleach.new)
  end

  def sanitized_mail_delivery(options = {})
    unless options.has_key?(:force_sanitize)
      options[:force_sanitize] = false
    end
    # Ensure that localish? will return sanitization_switch if true or false, and use proc when nil
    SanitizeEmail::Config.config[:force_sanitize] = options[:force_sanitize]
    Launchy.should_receive(:open)
    @mail_message = Mail.deliver do
      from      'from@example.org'
      to        'to@example.org'
      cc        'cc@example.org'
      bcc       'bcc@example.org'
      reply_to  'reply_to@example.org'
      subject   'original subject'
    end
    # All the email gets dumped to file once for each type of recipient (:to, :cc, :bcc)
    # Each file is identical, so we only need to check one of them:
    @email_file = File.read(Dir["#{@location}/*/plain.html"].first)
  end

  context "localish?" do
    before(:each) do
      sanitize_spec_dryer
      configure_sanitize_email
    end

    context "false" do
      it "alters nothing" do
        sanitized_mail_delivery(:force_sanitize => false)
        @email_file.should have_from("from@example.org")
        @email_file.should have_to("to@example.org")
        @mail_message.header.fields[3].value.should_not have_to("to at example.org")
        @mail_message.should have_cc("cc@example.org")
        @mail_message.should have_bcc("bcc@example.org")
        @email_file.should have_subject("original subject")
      end
    end

    context "true" do
      it "should override" do
        sanitized_mail_delivery(:force_sanitize => true)
        @email_file.should have_from("from@example.org")
        #puts "@mail_message.header.fields[3]: #{@mail_message.header.fields[3]}"
        #@mail_message.header.fields[3].value.should have_to("to at example.org")
        @mail_message.should have_cc("cc@sanitize_email.org")
        @mail_message.should have_bcc("bcc@sanitize_email.org")
        @email_file.should have_subject("(to at example.org) original subject")
      end
    end
  end

  context "deprecated config options" do
    context "local_environments" do
      it "should use local_environment_proc for matching environment" do
        sanitize_spec_dryer('test')
        configure_sanitize_email({:local_environments => ['test']})
        SanitizeEmail[:local_environment_proc].call.should == true
        sanitized_mail_delivery(:force_sanitize => nil)
        @email_file.should have_to("to@sanitize_email.org")
        @email_file.should have_subject("(to at example.org) original subject")
      end
      it "should use local_environment_proc for non-matching environment" do
        sanitize_spec_dryer('production')
        configure_sanitize_email({:local_environments => ['development']}) # Won't match!
        SanitizeEmail[:local_environment_proc].call.should == false
        sanitized_mail_delivery(:force_sanitize => nil)
        @mail_message.should_not have_subject("to at example.org")
      end
    end

    context "sanitized_recipients is set" do
      before(:each) do
        sanitize_spec_dryer
        configure_sanitize_email({:sanitized_recipients => 'barney@sanitize_email.org'})
      end
      it "used as sanitized_to" do
        sanitized_mail_delivery(:force_sanitize => true)
        @email_file.should have_from("from@example.org")
        @mail_message.should have_to("to@sanitize_email.org")
        @email_file.should have_subject("(to at example.org) original subject")
      end
    end
  end

end

#TODO: test good_list
