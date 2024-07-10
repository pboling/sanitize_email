class HelloMailer < ApplicationMailer
  default to: proc { "vonnegut@example.com" },
    reply_to: proc { "jingle-berry@example.com" },
    cc: proc { "charlie@example.org" },
    bcc: proc { "candy-mountain@example.org" }
  def bonjour
    mail(subject: "Your Roadside Bananas")
  end
end
