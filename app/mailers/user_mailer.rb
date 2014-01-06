class UserMailer < ActionMailer::Base
  default from: 'no-reply@autotest.io'

  def send_invitation_email(invited_user)
    @invited_user = invited_user
    @inviting_user = @invited_user.invited_by
    @invited_user.update_attribute(:invitation_sent_at, Time.now)
    mail to: invited_user.email, subject: "You're invited to try out AutoTest.io"
  end
end
