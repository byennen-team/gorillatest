class UserMailer < ActionMailer::Base
  default from: 'support@autotest.io'

  def send_invitation_email(invited_user)
    @invited_user = invited_user
    @inviting_user = @invited_user.invited_by
    @invited_user.update_attribute(:invitation_sent_at, Time.now)
    mail to: invited_user.email, subject: "You're invited to try out AutoTest.io"
  end

  def notify_failed_test(current_user_id, step, test_run)
    @step = step
    @test_run = test_run
    @scenario = @test_run.scenario
    @feature = @scenario.feature
    @project = @feature.project
    @user = User.find(current_user_id)
    mail to: @user.email, subject: "Project #{@project.name} just had a failed test run"
  end
end
