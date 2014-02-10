class UserMailer < ActionMailer::Base
  default from: 'support@autotest.io'

  def welcome_email(user)
    @user = user
    mail to: user.email, subject: "Welcome to AutoTest"
  end

  def send_invitation_email(invited_user)
    @invited_user = invited_user
    @inviting_user = @invited_user.invited_by
    @invited_user.update_attribute(:invitation_sent_at, Time.now)
    mail to: invited_user.email, subject: "You're invited to try out AutoTest.io"
  end

  def notify_failed_test(current_user_id, step, test_run_id)
    @step = step
    @test_run = TestRun.find(test_run_id)
    @scenario = @test_run.scenario
    @feature = @scenario.feature
    @project = @feature.project
    @user = User.find(current_user_id)
    mail to: @user.email, subject: "Project #{@project.name} just had a failed test run"
  end

  def notify_successful_test(user_id, test_run_id)
    @user = User.find(user_id)
    @test_run = TestRun.find(test_run_id)
    @scenario = @test_run.scenario
    @feature = @scenario.feature
    @project = @feature.project
    mail to: @user.email, subject: "Project #{@project.name} just had a successful test run"
  end
end
