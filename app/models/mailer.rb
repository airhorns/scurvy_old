class Mailer < ActionMailer::Base
  default :from => 'admin@scurvvy.info'
  
  def invitation(invitation, signup_url)
    @signup_url = signup_url
    mail :to => invitation.recipient_email, :subject => "scurvy invite"
  end
end