class InvitationMailer < ActionMailer::Base
  default from: "support@autotest.io"

  def send_invitation(user_id, inviter_id)
    @user = find_user(user_id)
    @inviting_user = @user.invited_by
    @user.update_attribute(:invitation_sent_at, Time.now)
    mail to: @user.email, subject: "You're invited to try out AutoTest.io"
  end

  def send_project_invitation(user_id, inviter_id, project_id)
    @user = find_user(user_id)
    @inviting_user = @user.encrypted_password.blank? ? @user.invited_by : find_user(inviter_id)
    @project = Project.find(project_id)
    mail to: @user.email, subject: "You've been invited to collaborate on project - #{@project.name}"
  end

  private

    def find_user(user_id)
      return User.find(user_id)
    end
end
