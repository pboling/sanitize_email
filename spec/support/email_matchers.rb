module EmailMatchers
  class UnexpectedMailType < StandardError; end

  def string_matching(matcher, part, mail_or_part)
    if mail_or_part.respond_to?(:=~) # Can we match a regex against it?
      mail_or_part =~ Regexp.new(Regexp.escape(matcher))
    else
      raise UnexpectedMailType, "Cannot match #{matcher} for #{part}"
    end
  end

  # Normalize arrays to strings
  def array_matching(matcher, part, mail_or_part)
    mail_or_part = mail_or_part.join(', ') if mail_or_part.respond_to?(:join)
    string_matching(matcher, part, mail_or_part)
  end

  def email_matching(matcher, part, mail_or_part)
    array_matching(matcher, part, mail_or_part.send(part))
  end

end

RSpec::Matchers.define :have_email_from do |from|
  include EmailMatchers
  match do |container|
    #puts "container: #{container}"
    email_matching(from, :from, container)
  end
end
RSpec::Matchers.define :have_email_to do |to|
  include EmailMatchers
  match do |container|
    email_matching(to, :to, container)
  end
end
RSpec::Matchers.define :have_email_cc do |cc|
  include EmailMatchers
  match do |container|
    email_matching(cc, :cc, container)
  end
end
# The ActionMailer :file delivery method never prints bcc recipients...
# Neither does LetterOpener :(
# But the mail object itself can be tested!
RSpec::Matchers.define :have_email_bcc do |bcc|
  include EmailMatchers
  match do |container|
    email_matching(bcc, :bcc, container)
  end
end
RSpec::Matchers.define :have_email_subject do |subject|
  include EmailMatchers
  match do |container|
    email_matching(subject, :subject, container)
  end
end

#RSpec::Matchers.define :have_email_to_username do |to|
#  include EmailMatcherHelpers
#  match do |container|
#    email_matching(to, :, container)
#  end
#end

RSpec::Matchers.define :have_file_from do |from|
  include EmailMatchers
  match do |container|
    #puts "container: #{container}"
    string_matching(from, :from, container)
  end
end
RSpec::Matchers.define :have_file_to do |to|
  include EmailMatchers
  match do |container|
    string_matching(to, :to, container)
  end
end
RSpec::Matchers.define :have_file_cc do |cc|
  include EmailMatchers
  match do |container|
    string_matching(cc, :cc, container)
  end
end
# The ActionMailer :file delivery method never prints bcc recipients...
# Neither does LetterOpener :(
# But the mail object itself can be tested!
RSpec::Matchers.define :have_file_bcc do |bcc|
  include EmailMatchers
  match do |container|
    string_matching(bcc, :bcc, container)
  end
end
RSpec::Matchers.define :have_file_subject do |subject|
  include EmailMatchers
  match do |container|
    string_matching(subject, :subject, container)
  end
end

#RSpec::Matchers.define :have_file_to_username do |to|
#  include EmailMatcherHelpers
#  match do |container|
#    email_matching(to, :, container)
#  end
#end
