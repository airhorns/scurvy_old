class Mailer < ActionMailer::Base
  def invitation(invitation, signup_url)
    subject    'scurvy invite'
    recipients invitation.recipient_email
    from       'admin@scurvy.com'
    body       :invitation => invitation, :signup_url => signup_url
  end
end
