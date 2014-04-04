class DashboardController < ApplicationController

  before_filter :authenticate_user!

  def index
    @projects = current_user.projects
    project_ids = current_user.projects.map(&:id)
    @project_last5tests = ProjectTestRun.in({project_id: project_ids}).limit(5).order('ran_at DESC').limit(5).to_a
    scenario_ids = Scenario.in({project_id: project_ids}).map(&:id)
    @scenario_last5tests = ScenarioTestRun.in({scenario_id: scenario_ids}).order('ran_at DESC').limit(5).to_a
    @last5_test_runs = @project_last5tests + @scenario_last5tests
    Rails.logger.debug(@project_last5tests.inspect)
    Rails.logger.debug(@scenario_last5tests.inspect)
    @last5_test_runs.sort_by!(&:ran_at).reverse!
  end

end
