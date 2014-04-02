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

  def notify_test_result(current_user_id, class_name, test_run_id)
    @user = User.find(current_user_id)
    @test_run = find_test_run(class_name, test_run_id)
    @project = @test_run.project
    @link_to_test_run = link_to_test_run(class_name, test_run_id)
    mail to: @user.email, subject: "[Autotest] Your tests have completed"
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

  def link_to_test_run(class_name, test_run_id)
    case class_name
    when 'project_test_run'
      return project_test_run_url(@test_run.project.id, @test_run.number, at_e: "completed_test")
    when 'feature_test_run'
      return project_feature_test_run_url(@test_run.project.id, @test_run.feature.id, @test_run.number, at_e: "completed_test")
    when 'scenario_test_run'
      return project_test_test_run_url(@test_run.project.id, @test_run.scenario.id, @test_run.number, at_e: "completed_test")
    end
  end

  def send_coupon_email(coupon_id, user_id)
    @coupon = Coupon.find(coupon_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "Here is a coupon code for additional minutes"
  end

  def script_verification(user_email, project_id)
    @project_id = project_id
    mail to: user_email, subject: "[Autotest] Your site is now setup!"
  end

  def plan_change(user_id, old_plan_id, new_plan_id)
    @user = User.find(user_id)
    @old_plan = Plan.find(old_plan_id)
    @new_plan = Plan.find(new_plan_id)
    mail to: @user.email, subject: "[Autotest] Your account has been updated"
  end

  def drip_email(user_id)
    @user = User.find(user_id)
    mail to: @user.email, from: "mike@autotest.io", subject: "Your Autotest Experience?"
  end
end
