class InvitationMailer < ActionMailer::Base
  default css: 'email', from: 'support@gorillatest.com'
  layout 'mailer'

  def send_invitation(user_id, inviter_id)
    @user = find_user(user_id)
    @inviting_user = @user.invited_by
    @user.update_attribute(:invitation_sent_at, Time.now)
    mail to: @user.email, subject: "You're invited to try out Gorilla Test"
  end

  def send_project_invitation_existing_user(user_id, inviter_id, project_id)
    @user = find_user(user_id)
    @inviting_user = find_user(inviter_id)
    @project = Project.find(project_id)
    mail to: @user.email, subject: "[Gorilla Test] You’ve been added to a project"
  end

  def send_project_invitation_new_user(user_id, inviter_id, project_id)
    @user = find_user(user_id)
    @inviting_user = @user.invited_by
    @project = Project.find(project_id)
    mail to: @user.email, subject: "You’re invited to join the team at Gorilla Test"
  end

  private

    def find_user(user_id)
      return User.find(user_id)
    end
end
