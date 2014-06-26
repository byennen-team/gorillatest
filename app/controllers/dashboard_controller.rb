class DashboardController < ApplicationController

  before_filter :authenticate_user!

  def index
    @projects = current_user.projects
    @concurrency_limit = current_user.plan.concurrent_browsers
    project_ids = current_user.projects.map(&:id)
    scenario_ids = Scenario.in({project_id: project_ids}).map(&:id)

    @project_tests = ProjectTestRun.in({project_id: project_ids})
    @scenario_tests = ScenarioTestRun.in({scenario_id: scenario_ids})
    @last5_test_runs = (@project_tests + @scenario_tests).sort_by{|run| run.ran_at || run.created_at}.reverse.first(5)
    Rails.logger.debug(@project_tests.inspect)
    Rails.logger.debug(@scenario_tests.inspect)
  end

end
