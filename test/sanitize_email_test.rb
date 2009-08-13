require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class SanitizeEmailTest < Test::Unit::TestCase
  def setup
    ENV['RAILS_ENV'] = 'test'
  end
  
  def prepare_sanitizations(to = nil, cc = nil, bcc = nil, use_actual_email_as_sanitized_user_name = false)
    ActionMailer::Base.sanitized_recipients = to
    ActionMailer::Base.sanitized_cc         = cc
    ActionMailer::Base.sanitized_bcc        = bcc
    ActionMailer::Base.local_environments = %w( test )
    ActionMailer::Base.use_actual_email_as_sanitized_user_name = use_actual_email_as_sanitized_user_name
  end

  def test_send_can_override_recips_cc_bcc_all_independently
    prepare_sanitizations("to_sanitized@email.com", "cc_sanitized@email.com")
    
    tmail = SampleMailer.create_gmail_override
    assert_equal ["to_sanitized@email.com"], tmail.to
    assert_equal ["cc_sanitized@email.com"], tmail.cc
    assert_equal nil,                        tmail.bcc
  end
  
  def test_to_with_override
    prepare_sanitizations("to_sanitized@email.com", nil, nil, :override_username)
    tmail = SampleMailer.create_gmail_override
    assert_equal "to_real@email.com", tmail.to_addrs[0].name
    assert_equal "to_sanitized@email.com", tmail.to_addrs[0].address
  end
  
  def test_tcc_with_override
    prepare_sanitizations("to_sanitized@email.com", "cc_sanitized@email.com", nil, :override_username)
    tmail = SampleMailer.create_gmail_override
    assert_equal "cc_real@email.com", tmail.cc_addrs[0].name
    assert_equal "cc_sanitized@email.com", tmail.cc_addrs[0].address
  end
  
  def test_bcc_with_override
    prepare_sanitizations("to_sanitized@email.com", nil, "bcc_sanitized@email.com", :override_username)
    tmail = SampleMailer.create_gmail_override
    assert_equal "bcc_real@email.com", tmail.bcc_addrs[0].name
    assert_equal "bcc_sanitized@email.com", tmail.bcc_addrs[0].address
  end
  
  def test_override_with_multiple_santiized_emails
    prepare_sanitizations(["to_0_sanitized@email.com", "to_1_sanitized@email.com"], nil, nil, :override_username)
    tmail = SampleMailer.create_gmail_override
    tmail.to_addrs.each_with_index do |mail, idx|
      assert_equal "to_real@email.com", mail.name
      assert_equal "to_#{idx}_sanitized@email.com", mail.address
    end
  end
  
  def test_overriding_multiple_real_addresses
    prepare_sanitizations("to_sanitized@email.com", nil, nil, :override_username)
    tmail = SampleMailer.create_gmail_override_multiple_recipient
    tmail.to_addrs.each_with_index do |mail, idx|
      assert_equal "to_#{idx}_real@email.com", mail.name
      assert_equal "to_sanitized@email.com", mail.address
    end
  end
  
  def test_overriding_multiple_real_addresses_with_multiple_sanitized_emails
    prepare_sanitizations(["to_0_sanitized@email.com", "to_1_sanitized@email.com"], nil, nil, :override_username)
    tmail = SampleMailer.create_gmail_override_multiple_recipient

    assert tmail.to_addrs.map(&:name).include?("to_0_real@email.com")
    assert tmail.to_addrs.map(&:name).include?("to_1_real@email.com")
    
    assert tmail.to_addrs.map(&:address).include?("to_0_sanitized@email.com")
    assert tmail.to_addrs.map(&:address).include?("to_1_sanitized@email.com")
  end
  

end
