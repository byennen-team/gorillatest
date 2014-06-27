class UserMailer < ActionMailer::Base
  default css: 'email', from: 'support@gorillatest.com'
  layout 'layouts/mailer'

  def welcome_email(user)
    @user = user
    mail to: user.email, subject: "Welcome to GorillaTest"
  end

  def send_invitation_email(invited_user_id)
    @invited_user = User.find(invited_user_id)
    @inviting_user = @invited_user.invited_by
    @invited_user.update_attribute(:invitation_sent_at, Time.now)
    mail to: @invited_user.email, subject: "You're invited to try out Gorilla Test"
  end

  def notify_test_result(current_user_id, class_name, test_run_id)
    @user = User.find(current_user_id)
    @test_run = find_test_run(class_name, test_run_id)
    @project = @test_run.project
    @link_to_test_run = link_to_test_run(class_name, test_run_id)
    mail to: @user.email, subject: "[GorillaTest] Your tests have completed"
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
      return project_test_run_url(@test_run.project, @test_run, at_e: "completed_test")
    when 'feature_test_run'
      return project_feature_test_run_url(@test_run.project, @test_run.feature, @test_run, at_e: "completed_test")
    when 'scenario_test_run'
      return project_test_test_run_url(@test_run.project, @test_run.scenario, @test_run, at_e: "completed_test")
    end
  end

  def send_coupon_email(coupon_id, user_id)
    @coupon = Coupon.find(coupon_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "Here is a coupon code for additional minutes"
  end

  def script_verification(user_email, project_id)
    @project_id = project_id
    mail to: user_email, subject: "[GorillaTest] Your site is now setup!"
  end

  def plan_change(user_id, old_plan_id, new_plan_id)
    @user = User.find(user_id)
    @old_plan = Plan.find(old_plan_id)
    @new_plan = Plan.find(new_plan_id)
    mail to: @user.email, subject: "[GorillaTest] Your account has been updated"
  end

  def drip_email(user_id)
    @user = User.find(user_id)
    mail to: @user.email, from: "mike@gorillatest.com", subject: "Your GorillaTest Experience?"
  end

  def test_run_details_for_developer(user_email, email, test_run_type, test_run_id)
    # only passing in scenario test runs for now
    if test_run_type == "ScenarioTestRun"
      @test_run = ScenarioTestRun.find(test_run_id)
      @scenario = @test_run.scenario
      @developer_mode_url = developer_mode_url(@scenario)
    else
      @test_run = ProjectTestRun.find(test_run_id)
    end
    @project = @test_run.project

    mail to: email, from: user_email, subject: "Test Results from Gorilla Test"
  end

  def test_details_for_developer(user_email, email, test_id)
    @test = Scenario.find(test_id)
    @project = @test.project
    @developer_mode_url = developer_mode_url(@test)
    mail to: email, from: user_email, subject: "Test Details from Gorilla Test"
  end

  private

  def developer_mode_url(scenario)
    join_char = scenario.steps.first.text.include?("?") ? "&" : "?"
    "#{scenario.steps.first.text}#{join_char}developer=true&scenario_id=#{scenario.id.to_s}"
  end
end
