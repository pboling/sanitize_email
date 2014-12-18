# Copyright (c) 2008-13 Peter H. Boling of RailsBling.com
# Released under the MIT license
require 'spec_helper'

#
# TODO: Letter Opener should *not* be required, but setting the delivery method to :file was causing connection errors... WTF?
#
describe SanitizeEmail do

  DEFAULT_TEST_CONFIG = {
    :sanitized_cc =>  'cc@sanitize_email.org',
    :sanitized_bcc => 'bcc@sanitize_email.org',
    :use_actual_email_prepended_to_subject => false,
    :use_actual_environment_prepended_to_subject => false,
    :use_actual_email_as_sanitized_user_name => false
  }

  before(:all) do
    SanitizeEmail::Deprecation.deprecate_in_silence = true
  end

  # Cleanup, so tests don't bleed
  after(:each) do
    SanitizeEmail::Config.config = SanitizeEmail::Config::DEFAULTS
    SanitizeEmail.force_sanitize = nil
    # The following works with Ruby > 1.9, but to make the test suite run on 18.7 we need a little help
    # Mail.class_variable_get(:@@delivery_interceptors).pop
    Mail.send(:class_variable_get, :@@delivery_interceptors).pop
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
      config[:use_actual_environment_prepended_to_subject] = options[:use_actual_environment_prepended_to_subject]
      config[:use_actual_email_as_sanitized_user_name] = options[:use_actual_email_as_sanitized_user_name]

      # For testing *deprecated* configuration options:
      config[:local_environments] =   options[:local_environments] if options[:local_environments]
      config[:sanitized_recipients] = options[:sanitized_recipients] if options[:sanitized_recipients]
      config[:force_sanitize] = options[:force_sanitize] unless options[:force_sanitize].nil?
    end
    Mail.register_interceptor(SanitizeEmail::Bleach.new)
  end

  def funky_config
    SanitizeEmail::Config.configure do |config|
      config[:sanitized_to] =         %w( funky@sanitize_email.org yummy@sanitize_email.org same@example.org )
      config[:sanitized_cc] =         nil
      config[:sanitized_bcc] =        nil
      # run/call whatever logic should turn sanitize_email on and off in this Proc:
      config[:activation_proc] =      Proc.new { Rails.env != 'production' }
      config[:use_actual_email_prepended_to_subject] = true
      config[:use_actual_environment_prepended_to_subject] = true
      config[:use_actual_email_as_sanitized_user_name] = false
    end
    Mail.register_interceptor(SanitizeEmail::Bleach.new)
  end

  def sanitary_mail_delivery(config_options = {})
    SanitizeEmail.sanitary(config_options) do
      mail_delivery
    end
  end

  def sanitary_mail_delivery_multiple_recipients(config_options = {})
    SanitizeEmail.sanitary(config_options) do
      mail_delivery_multiple_recipients
    end
  end

  def unsanitary_mail_delivery
    SanitizeEmail.unsanitary do
      mail_delivery
    end
  end

  def mail_delivery_hot_mess
    @email_message = Mail.deliver do
      from      'same@example.org'
      to        %w( same@example.org same@example.org same@example.org same@example.org same@example.org )
      cc        'same@example.org'
      bcc       'same@example.org'
      reply_to  'same@example.org'
      subject   'original subject'
      body      'funky fresh'
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
      body      'funky fresh'
    end
  end

  def mail_delivery_multiple_recipients
    @email_message = Mail.deliver do
      from      'from@example.org'
      to        %w( to1@example.org to2@example.org to3@example.org )
      cc        %w( cc1@example.org cc2@example.org cc3@example.org )
      bcc       %w( bcc1@example.org bcc2@example.org bcc3@example.org )
      reply_to  'reply_to@example.org'
      subject   'original subject'
      body      'funky fresh'
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
        @email_message.should have_body_text('funky fresh')
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
        @email_message.should have_body_text('funky fresh')
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
        @email_message.should have_body_text('funky fresh')
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
      it "should set headers" do
        @email_message.should have_header("X-Sanitize-Email-To", "to@example.org")
        @email_message.should have_header("X-Sanitize-Email-Cc", "cc@example.org")
        @email_message.should_not have_header("X-Sanitize-Email-Bcc", "bcc@sanitize_email.org")
      end
      it "should not prepend originals by default" do
        @email_message.should_not have_to_username("to at example.org <to@sanitize_email.org>")
        @email_message.should_not have_subject("(to at example.org) original subject")
      end
    end

    context "sanitary with multiple recipients" do
      before(:each) do
        configure_sanitize_email
        sanitary_mail_delivery_multiple_recipients
      end
      it "should not alter non-sanitized attributes" do
        @email_message.should have_from('from@example.org')
        @email_message.should have_reply_to('reply_to@example.org')
        @email_message.should have_body_text('funky fresh')
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
      it "should set headers for sanitized :to recipients" do
        @email_message.should have_header("X-Sanitize-Email-To", "to1@example.org")
        @email_message.should_not have_header("X-Sanitize-Email-To-0", "to1@example.org")
        @email_message.should_not have_header("X-Sanitize-Email-To-1", "to1@example.org")
        @email_message.should have_header("X-Sanitize-Email-To-2", "to2@example.org")
        @email_message.should have_header("X-Sanitize-Email-To-3", "to3@example.org")
      end
      it "should set headers for sanitized :cc recipients" do
        @email_message.should have_header("X-Sanitize-Email-Cc", "cc1@example.org")
        @email_message.should_not have_header("X-Sanitize-Email-Cc-0", "cc1@example.org")
        @email_message.should_not have_header("X-Sanitize-Email-Cc-1", "cc1@example.org")
        @email_message.should have_header("X-Sanitize-Email-Cc-2", "cc2@example.org")
        @email_message.should have_header("X-Sanitize-Email-Cc-3", "cc3@example.org")
      end
      it "should not set headers for sanitized :bcc recipients" do
        @email_message.should_not have_header("X-Sanitize-Email-Bcc", "bcc1@sanitize_email.org")
        @email_message.should_not have_header("X-Sanitize-Email-Bcc-0", "bcc1@sanitize_email.org")
        @email_message.should_not have_header("X-Sanitize-Email-Bcc-1", "bcc1@sanitize_email.org")
        @email_message.should_not have_header("X-Sanitize-Email-Bcc-2", "bcc2@sanitize_email.org")
        @email_message.should_not have_header("X-Sanitize-Email-Bcc-3", "bcc3@sanitize_email.org")
      end
      it "should not prepend originals by default" do
        @email_message.should_not have_to_username("to at example.org <to@sanitize_email.org>")
        @email_message.should_not have_subject("(to at example.org) original subject")
      end
    end

    context "sanitary with funky config" do
      before(:each) do
        funky_config
        SanitizeEmail.force_sanitize = true
        mail_delivery
      end
      it "original to is prepended to subject" do
        @email_message.should have_subject(/\(to at example.org\).*original subject/)
      end
      it "original to is only prepended once to subject" do
        @email_message.should_not have_subject(/\(to at example.org\).*\(to at example.org\).*original subject/)
      end
      it "should not alter non-sanitized attributes" do
        @email_message.should have_from('from@example.org')
        @email_message.should have_reply_to('reply_to@example.org')
        @email_message.should have_body_text('funky fresh')
      end
      it "should not prepend overrides" do
        @email_message.should_not have_to_username("to at sanitize_email.org")
        @email_message.should_not have_subject(/.*\(to at sanitize_email.org\).*/)
      end
      it "should override where original recipients were not nil" do
        @email_message.should have_to("funky@sanitize_email.org")
      end
      it "should not override where original recipients were nil" do
        @email_message.should_not have_cc("cc@sanitize_email.org")
        @email_message.should_not have_bcc("bcc@sanitize_email.org")
      end
      it "should set headers of originals" do
        @email_message.should have_header("X-Sanitize-Email-To", "to@example.org")
        @email_message.should have_header("X-Sanitize-Email-Cc", "cc@example.org")
      end
      it "should not set headers of bcc" do
        @email_message.should_not have_header("X-Sanitize-Email-Bcc", "bcc@sanitize_email.org")
      end
      it "should not set headers of overrides" do
        @email_message.should_not have_header("X-Sanitize-Email-To", "funky@sanitize_email.org")
        @email_message.should_not have_header("X-Sanitize-Email-Cc", "cc@sanitize_email.org")
        @email_message.should_not have_header("X-Sanitize-Email-Bcc", "bcc@sanitize_email.org")
        #puts "email headers:\n#{@email_message.header}"
      end
      it "should not prepend originals by default" do
        @email_message.should_not have_to_username("to at example.org <to@sanitize_email.org>")
        @email_message.should_not have_subject("(to at example.org) original subject")
      end
    end

    context "sanitary with funky config and hot mess delivery" do
      before(:each) do
        funky_config
        SanitizeEmail.force_sanitize = true
        mail_delivery_hot_mess
      end
      it "original to is prepended to subject" do
        @email_message.should have_subject(/\(same at example.org\).*original subject/)
      end
      it "original to is only prepended once to subject" do
        @email_message.should_not have_subject(/\(same at example.org\).*\(same at example.org\).*original subject/)
      end
      it "should not alter non-sanitized attributes" do
        @email_message.should have_from('same@example.org')
        @email_message.should have_reply_to('same@example.org')
        @email_message.should have_body_text('funky fresh')
      end
      it "should not prepend overrides" do
        @email_message.should_not have_to_username("same at example.org")
      end
      it "should override where original recipients were not nil" do
        @email_message.should have_to("same@example.org")
      end
      it "should not override where original recipients were nil" do
        @email_message.should_not have_cc("same@example.org")
        @email_message.should_not have_bcc("same@example.org")
      end
      it "should set headers of originals" do
        @email_message.should have_header("X-Sanitize-Email-To", "same@example.org")
        @email_message.should have_header("X-Sanitize-Email-Cc", "same@example.org")
      end
      it "should not set headers of bcc" do
        @email_message.should_not have_header("X-Sanitize-Email-Bcc", "same@example.org")
      end
      it "should not set headers of overrides" do
        @email_message.should_not have_header("X-Sanitize-Email-Bcc", "same@example.org")
        puts "email headers:\n#{@email_message.header}"
      end
      it "should not prepend originals by default" do
        @email_message.should_not have_to_username("same at example.org <same@example.org>")
        @email_message.should_not have_subject("(same at example.org) original subject")
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
          @email_message.should have_body_text('funky fresh')
        end
        it "should override" do
          @email_message.should have_to("to@sanitize_email.org")
          @email_message.should have_cc("cc@sanitize_email.org")
          @email_message.should have_bcc("bcc@sanitize_email.org")
        end
        it "should set headers" do
          @email_message.should have_header("X-Sanitize-Email-To", "to@example.org")
          @email_message.should have_header("X-Sanitize-Email-Cc", "cc@example.org")
          @email_message.should_not have_header("X-Sanitize-Email-Bcc", "bcc@sanitize_email.org")
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
          @email_message.should have_body_text('funky fresh')
        end
        it "should not alter normally sanitized attributes" do
          @email_message.should have_to("to@example.org")
          @email_message.should have_cc("cc@example.org")
          @email_message.should have_bcc("bcc@example.org")
          @email_message.should_not have_header("X-Sanitize-Email-To", "to@example.org")
          @email_message.should_not have_header("X-Sanitize-Email-Cc", "cc@example.org")
          @email_message.should_not have_header("X-Sanitize-Email-Bcc", "bcc@example.org")
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
            @email_message.should have_body_text('funky fresh')
          end
          it "should override" do
            @email_message.should have_to("to@sanitize_email.org")
            @email_message.should have_cc("cc@sanitize_email.org")
            @email_message.should have_bcc("bcc@sanitize_email.org")
            @email_message.should have_header("X-Sanitize-Email-To", "to@example.org")
            @email_message.should have_header("X-Sanitize-Email-Cc", "cc@example.org")
            @email_message.should_not have_header("X-Sanitize-Email-Bcc", "bcc@sanitize_email.org")
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
            @email_message.should have_body_text('funky fresh')
          end
          it "should not alter normally sanitized attributes" do
            @email_message.should have_to("to@example.org")
            @email_message.should have_cc("cc@example.org")
            @email_message.should have_bcc("bcc@example.org")
            @email_message.should_not have_header("X-Sanitize-Email-To", "to@example.org")
            @email_message.should_not have_header("X-Sanitize-Email-Cc", "cc@example.org")
            @email_message.should_not have_header("X-Sanitize-Email-Bcc", "bcc@example.org")
          end
        end
      end
    end
  end

  context "config options" do
    context ":use_actual_environment_prepended_to_subject" do
      context "true" do
        before(:each) do
          sanitize_spec_dryer('test')
          configure_sanitize_email({:use_actual_environment_prepended_to_subject => true})
          sanitary_mail_delivery
        end
        it "original to is prepended" do
          @email_message.should have_subject("[test] original subject")
        end
        it "should not alter non-sanitized attributes" do
          @email_message.should have_from('from@example.org')
          @email_message.should have_reply_to('reply_to@example.org')
          @email_message.should have_body_text('funky fresh')
        end
        it "should not prepend overrides" do
          @email_message.should_not have_to_username("to at sanitize_email.org")
          @email_message.should_not have_subject("(to at sanitize_email.org)")
        end
      end
      context "false" do
        before(:each) do
          sanitize_spec_dryer('test')
          configure_sanitize_email({:use_actual_environment_prepended_to_subject => false})
          sanitary_mail_delivery
        end
        it "original to is not prepended" do
          @email_message.should_not      have_subject("[test] original subject")
          @email_message.subject.should  eq("original subject")
        end
        it "should not alter non-sanitized attributes" do
          @email_message.should have_from('from@example.org')
          @email_message.should have_reply_to('reply_to@example.org')
          @email_message.should have_body_text('funky fresh')
        end
        it "should not prepend overrides" do
          @email_message.should_not have_to_username("to at sanitize_email.org")
          @email_message.should_not have_subject("(to at sanitize_email.org)")
        end
      end
    end

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
          @email_message.should have_body_text('funky fresh')
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
          @email_message.should have_body_text('funky fresh')
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
          @email_message.should have_body_text('funky fresh')
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
          @email_message.should have_body_text('funky fresh')
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
            @email_message.should have_body_text('funky fresh')
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
            @email_message.should have_body_text('funky fresh')
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
          @email_message.should have_body_text('funky fresh')
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
          @email_message.should have_body_text('funky fresh')
        end
        it "should not alter normally sanitized attributes" do
          @email_message.should have_to("to@example.org")
        end
      end

    end
  end
end

#TODO: test good_list
