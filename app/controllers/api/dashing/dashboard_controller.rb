class Api::Dashing::DashboardController < Api::Dashing::BaseController

  def total_tests_run
    render json: {scenario_test_runs: ScenarioTestRun.all.map(&:browser_tests).map(&:count).sum,
                  feature_test_runs: FeatureTestRun.all.map(&:browser_tests).map(&:count).sum,
                  project_test_runs: ProjectTestRun.all.map(&:browser_tests).map(&:count).sum}
  end

end
