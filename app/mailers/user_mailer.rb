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

  def notify_failed_test(current_user_id, class_name, test_run_id)
    @user = User.find(current_user_id)
    @test_run = find_test_run(class_name, test_run_id)
    @project = @test_run.project
    mail to: @user.email, subject: "Project #{@project.name} just had a failed test run"
  end

  def notify_successful_test(user_id, class_name, test_run_id)
    @user = User.find(user_id)
    @test_run = find_test_run(class_name, test_run_id)
    @project = @test_run.project
    mail to: @user.email, subject: "Project #{@project.name} just had a successful test run"
  end

  def find_test_run(class_name, test_run_id)
    case class_name
    when 'project_test_run'
      return ProjectTestRun.find(test_run_id)
    when 'feature_test_run'
      return FeatureTestRun.find(test_run_id)
    when 'scenario_test_run'
      return ScenarioTestRun.find(test_run_id)
    end
  end

  def send_coupon_email(coupon_id, user_id)
    @coupon = Coupon.find(coupon_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "Here is a coupon code for additional minutes"
  end
end
