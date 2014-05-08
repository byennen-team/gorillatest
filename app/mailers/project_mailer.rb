class ProjectMailer < ActionMailer::Base
  default from: 'support@gorillatest.com'
  layout 'mailer'

  def verification(project_id)
    @project = Project.find(project_id)
    mail to: @project.creator.email, subject: "You're project has been verified."
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

