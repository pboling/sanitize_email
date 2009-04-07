require 'test/unit'
require 'test/sample_mailer'

class SanitizeEmailTest < Test::Unit::TestCase

  def test_send_can_override_recips_cc_bcc_all_independently
    # configure SanitizeEmail
    ActionMailer::Base.sanitized_recipients = "john@smartlogicsolutions.com"
    ActionMailer::Base.sanitized_bcc = nil
    ActionMailer::Base.sanitized_cc = "john@smartlogicsolutions.com"
    ActionMailer::Base.local_environments = %w( test )
    ENV['RAILS_ENV'] = 'test'
    
    # the mailer sets all 3 of these values to "jtrupiano@gmail.com".  We override them independently
    tmail = SampleMailer.create_gmail_override
    assert_equal ["john@smartlogicsolutions.com"], tmail.to
    assert_equal ["john@smartlogicsolutions.com"], tmail.cc
    assert_equal nil, tmail.bcc
  end

end
