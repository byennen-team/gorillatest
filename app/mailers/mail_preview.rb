class MailPreview < MailView
    # Pull data from existing fixtures
  def notify_failed_test
    # @project = Project.last
    # @feature = @project.features.last
    # @scenario = @feature.scenarios.find_by(name:"Failing Scenario")
    # @test_run = @scenario.test_runs.last
    # @statuses = @test_run.platforms_browsers_statuses
    # UserMailer.notify_failed_test(User.first.id.to_s, @test_run.browser_tests.last.steps.last, @test_run.id.to_s)
  end
end
