
require 'rubygems'
require 'action_mailer'

# configure ActionMailer
ActionMailer::Base.template_root = "."

require File.join(File.dirname(__FILE__), "..", "lib", 'sanitize_email')


class SampleMailer < ActionMailer::Base
  
  def gmail_override
    # set them all to send to gmail
    @recipients = "jtrupiano@gmail.com"
    @cc         = "jtrupiano@gmail.com"
    @bcc        = "jtrupiano@gmail.com"

    @subject = "Hello there"
    
    part :content_type => "text/html", :body => "Hello there"
  end

end