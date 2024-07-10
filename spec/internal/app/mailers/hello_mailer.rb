class HelloMailer < ApplicationMailer
  default to: -> { "vonnegut@example.com" },
    reply_to: -> { "jingle-berry@example.com" },
    cc: -> { "charlie@example.org" },
    bcc: -> { "candy-mountain@example.org" }
  def bonjour
    mail(subject: "Your Roadside Bananas")
  end
end
