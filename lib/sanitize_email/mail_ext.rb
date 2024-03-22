# frozen_string_literal: true

require "mail"

# Cribbed from email_spec gem
module SanitizeEmail::MailExt
  def default_part
    @default_part ||= html_part || text_part || self
  end

  def default_part_body
    default_part.body
  end
end

Mail::Message.send(:include, SanitizeEmail::MailExt)
