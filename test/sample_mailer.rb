class SampleMailer < ActionMailer::Base
  
  def gmail_override
    @recipients = "to_real@email.com"
    @cc         = "cc_real@email.com"
    @bcc        = "bcc_real@email.com"

    @subject = "Hello there"
    
    part :content_type => "text/html", :body => "Hello there"
  end
  
  def gmail_override_multiple_recipient
    @recipients = ["to_0_real@email.com", "to_1_real@email.com"]
    @cc         = "cc_real@email.com"
    @bcc        = "bcc_real@email.com"

    @subject = "Hello there, multiple"
    
    part :content_type => "text/html", :body => "Hello there, multiple."
    
  end

end
