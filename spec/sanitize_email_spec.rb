require 'spec_helper'

#
# TODO: Letter Opener should *not* be required, but setting the delivery method to :file was causing connection errors... WTF?
#
describe SanitizeEmail do

  DEFAULT_TEST_CONFIG = {
    :sanitized_cc =>  'cc@sanitize_email.org',
    :sanitized_bcc => 'bcc@sanitize_email.org',
    :use_actual_email_prepended_to_subject => false,
    :use_actual_email_as_sanitized_user_name => false
  }

  before(:all) do
    SanitizeEmail::Deprecation.deprecate_in_silence = true
  end

  # Cleanup, so tests don't bleed
  after(:each) do
    SanitizeEmail::Config.config = SanitizeEmail::Config::DEFAULTS
    SanitizeEmail.force_sanitize = nil
    Mail.class_variable_get(:@@delivery_interceptors).pop
  end

  def sanitize_spec_dryer(rails_env = 'test')
    Launchy.stub(:open)
    location = File.expand_path('../tmp/mail_dump', __FILE__)
    FileUtils.rm_rf(location)
    Mail.defaults do
      delivery_method LetterOpener::DeliveryMethod, :location => location
    end
    Rails.stub(:env).and_return(rails_env)
  end

  def configure_sanitize_email(sanitize_hash = {})
    options = DEFAULT_TEST_CONFIG.merge(sanitize_hash).dup
    options.reverse_merge!({ :sanitized_to => 'to@sanitize_email.org' }) unless sanitize_hash.has_key?(:sanitized_recipients)
    SanitizeEmail::Config.configure do |config|
      config[:activation_proc] =      options[:activation_proc]
      config[:sanitized_to] =         options[:sanitized_to]
      config[:sanitized_cc] =         options[:sanitized_cc]
      config[:sanitized_bcc] =        options[:sanitized_bcc]
      config[:use_actual_email_prepended_to_subject] = options[:use_actual_email_prepended_to_subject]
      config[:use_actual_email_as_sanitized_user_name] = options[:use_actual_email_as_sanitized_user_name]

      # For testing *deprecated* configuration options:
      config[:local_environments] =   options[:local_environments] if options[:local_environments]
      config[:sanitized_recipients] = options[:sanitized_recipients] if options[:sanitized_recipients]
      config[:force_sanitize] = options[:force_sanitize] unless options[:force_sanitize].nil?
    end
    Mail.register_interceptor(SanitizeEmail::Bleach.new)
  end

  def sanitary_mail_delivery(config_options = {})
    SanitizeEmail.sanitary(config_options) do
      mail_delivery
    end
  end

  def unsanitary_mail_delivery
    SanitizeEmail.unsanitary do
      mail_delivery
    end
  end

  def mail_delivery
    @email_message = Mail.deliver do
      from      'from@example.org'
      to        'to@example.org'
      cc        'cc@example.org'
      bcc       'bcc@example.org'
      reply_to  'reply_to@example.org'
      subject   'original subject'
    end
  end

  context "module methods" do
    before(:each) do
      sanitize_spec_dryer
    end

    context "unsanitary" do
      before(:each) do
        configure_sanitize_email
        unsanitary_mail_delivery
      end
      it "should not alter non-sanitized attributes" do
        @email_message.should have_from('from@example.org')
        @email_message.should have_reply_to('reply_to@example.org')
      end
      it "should not prepend overrides" do
        @email_message.should_not have_to_username("to at sanitize_email.org")
        @email_message.should_not have_subject("(to at sanitize_email.org)")
      end
      it "alters nothing" do
        @email_message.should have_from('from@example.org')
        @email_message.should have_reply_to('reply_to@example.org')
        @email_message.should have_from("from@example.org")
        @email_message.should have_to("to@example.org")
        @email_message.should_not have_to_username("to at")
        @email_message.should have_cc("cc@example.org")
        @email_message.should have_bcc("bcc@example.org")
        @email_message.should have_subject("original subject")
      end
    end

    context "sanitary" do
      before(:each) do
        configure_sanitize_email
        sanitary_mail_delivery
      end
      it "should not alter non-sanitized attributes" do
        @email_message.should have_from('from@example.org')
        @email_message.should have_reply_to('reply_to@example.org')
      end
      it "should not prepend overrides" do
        @email_message.should_not have_to_username("to at sanitize_email.org")
        @email_message.should_not have_subject("(to at sanitize_email.org)")
      end
      it "should override" do
        @email_message.should have_to("to@sanitize_email.org")
        @email_message.should have_cc("cc@sanitize_email.org")
        @email_message.should have_bcc("bcc@sanitize_email.org")
      end
      it "should not prepend originals by default" do
        @email_message.should_not have_to_username("to at example.org <to@sanitize_email.org>")
        @email_message.should_not have_subject("(to at example.org) original subject")
      end
    end

    context "force_sanitize" do
      context "true" do
        before(:each) do
          # Should turn off sanitization using the force_sanitize
          configure_sanitize_email({:activation_proc => Proc.new {true}})
          SanitizeEmail.force_sanitize = true
          mail_delivery
        end
        it "should not alter non-sanitized attributes" do
          @email_message.should have_from('from@example.org')
          @email_message.should have_reply_to('reply_to@example.org')
        end
        it "should override" do
          @email_message.should have_to("to@sanitize_email.org")
          @email_message.should have_cc("cc@sanitize_email.org")
          @email_message.should have_bcc("bcc@sanitize_email.org")
        end
      end
      context "false" do
        before(:each) do
          # Should turn off sanitization using the force_sanitize
          configure_sanitize_email({:activation_proc => Proc.new {true}})
          SanitizeEmail.force_sanitize = false
          mail_delivery
        end
        it "should not alter non-sanitized attributes" do
          @email_message.should have_from('from@example.org')
          @email_message.should have_reply_to('reply_to@example.org')
        end
        it "should not alter normally sanitized attributes" do
          @email_message.should have_to("to@example.org")
          @email_message.should have_cc("cc@example.org")
          @email_message.should have_bcc("bcc@example.org")
        end
      end
      context "nil" do
        context "activation proc enables" do
          before(:each) do
            sanitize_spec_dryer
            # Should ignore force_sanitize setting
            configure_sanitize_email({:activation_proc => Proc.new {true}})
            SanitizeEmail.force_sanitize = nil
            mail_delivery
          end
          it "should not alter non-sanitized attributes" do
            @email_message.should have_from('from@example.org')
            @email_message.should have_reply_to('reply_to@example.org')
          end
          it "should override" do
            @email_message.should have_to("to@sanitize_email.org")
            @email_message.should have_cc("cc@sanitize_email.org")
            @email_message.should have_bcc("bcc@sanitize_email.org")
          end
        end
        context "activation proc disables" do
          before(:each) do
            sanitize_spec_dryer
            # Should ignore force_sanitize setting
            configure_sanitize_email({:activation_proc => Proc.new {false}})
            SanitizeEmail.force_sanitize = nil
            mail_delivery
          end
          it "should not alter non-sanitized attributes" do
            @email_message.should have_from('from@example.org')
            @email_message.should have_reply_to('reply_to@example.org')
          end
          it "should not alter normally sanitized attributes" do
            @email_message.should have_to("to@example.org")
            @email_message.should have_cc("cc@example.org")
            @email_message.should have_bcc("bcc@example.org")
          end
        end
      end
    end
  end

  context "config options" do
    context ":use_actual_email_prepended_to_subject" do
      context "true" do
        before(:each) do
          sanitize_spec_dryer
          configure_sanitize_email({:use_actual_email_prepended_to_subject => true})
          sanitary_mail_delivery
        end
        it "original to is prepended" do
          @email_message.should have_subject("(to at example.org) original subject")
        end
        it "should not alter non-sanitized attributes" do
          @email_message.should have_from('from@example.org')
          @email_message.should have_reply_to('reply_to@example.org')
        end
        it "should not prepend overrides" do
          @email_message.should_not have_to_username("to at sanitize_email.org")
          @email_message.should_not have_subject("(to at sanitize_email.org)")
        end
      end
      context "false" do
        before(:each) do
          sanitize_spec_dryer
          configure_sanitize_email({:use_actual_email_prepended_to_subject => false})
          sanitary_mail_delivery
        end
        it "original to is not prepended" do
          @email_message.should_not have_subject("(to at example.org) original subject")
        end
        it "should not alter non-sanitized attributes" do
          @email_message.should have_from('from@example.org')
          @email_message.should have_reply_to('reply_to@example.org')
        end
        it "should not prepend overrides" do
          @email_message.should_not have_to_username("to at sanitize_email.org")
          @email_message.should_not have_subject("(to at sanitize_email.org)")
        end
      end
    end

    context ":use_actual_email_as_sanitized_user_name" do
      context "true" do
        before(:each) do
          sanitize_spec_dryer
          configure_sanitize_email({:use_actual_email_as_sanitized_user_name => true})
          sanitary_mail_delivery
        end
        it "original to is munged and prepended" do
          @email_message.should have_to_username("to at example.org <to@sanitize_email.org>")
        end
        it "should not alter non-sanitized attributes" do
          @email_message.should have_from('from@example.org')
          @email_message.should have_reply_to('reply_to@example.org')
        end
        it "should not prepend overrides" do
          @email_message.should_not have_to_username("to at sanitize_email.org")
          @email_message.should_not have_subject("(to at sanitize_email.org)")
        end
      end
      context "false" do
        before(:each) do
          sanitize_spec_dryer
          configure_sanitize_email({:use_actual_email_as_sanitized_user_name => false})
          sanitary_mail_delivery
        end
        it "original to is not prepended" do
          @email_message.should_not have_to_username("to at example.org <to@sanitize_email.org>")
        end
        it "should not alter non-sanitized attributes" do
          @email_message.should have_from('from@example.org')
          @email_message.should have_reply_to('reply_to@example.org')
        end
        it "should not prepend overrides" do
          @email_message.should_not have_to_username("to at sanitize_email.org")
          @email_message.should_not have_subject("(to at sanitize_email.org)")
        end
      end
    end

    context "deprecated" do
      #before(:each) do
      #  SanitizeEmail::Deprecation.deprecate_in_silence = false
      #end
      context ":local_environments" do
        context "matching" do
          before(:each) do
            sanitize_spec_dryer('test')
            configure_sanitize_email({:local_environments => ['test']})
            SanitizeEmail[:activation_proc].call.should == true
            mail_delivery
          end
          it "should not alter non-sanitized attributes" do
            @email_message.should have_from('from@example.org')
            @email_message.should have_reply_to('reply_to@example.org')
          end
          it "should use activation_proc for matching environment" do
            @email_message.should have_to("to@sanitize_email.org")
            @email_message.should have_cc("cc@sanitize_email.org")
            @email_message.should have_bcc("bcc@sanitize_email.org")
          end
        end
        context "non-matching" do
          before(:each) do
            sanitize_spec_dryer('production')
            configure_sanitize_email({:local_environments => ['development']}) # Won't match!
            SanitizeEmail[:activation_proc].call.should == false
            mail_delivery
          end
          it "should not alter non-sanitized attributes" do
            @email_message.should have_from('from@example.org')
            @email_message.should have_reply_to('reply_to@example.org')
          end
          it "should use activation_proc for non-matching environment" do
            @email_message.should have_to("to@example.org")
            @email_message.should have_cc("cc@example.org")
            @email_message.should have_bcc("bcc@example.org")
          end
        end
      end

      context ":sanitized_recipients" do
        before(:each) do
          sanitize_spec_dryer
          configure_sanitize_email({:sanitized_recipients => 'barney@sanitize_email.org'})
          sanitary_mail_delivery
        end
        it "should not alter non-sanitized attributes" do
          @email_message.should have_from('from@example.org')
          @email_message.should have_reply_to('reply_to@example.org')
        end
        it "used as sanitized_to" do
          @email_message.should have_to("barney@sanitize_email.org")
        end
      end

      context ":force_sanitize" do
        before(:each) do
          sanitize_spec_dryer
          # Should turn off sanitization using the force_sanitize
          configure_sanitize_email({:activation_proc => Proc.new {true}, :force_sanitize => false})
          mail_delivery
        end
        it "should not alter non-sanitized attributes" do
          @email_message.should have_from('from@example.org')
          @email_message.should have_reply_to('reply_to@example.org')
        end
        it "should not alter normally sanitized attributes" do
          @email_message.should have_to("to@example.org")
        end
      end

    end
  end
end

#TODO: test good_list
