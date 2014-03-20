class Api::Dashing::DashboardController < Api::Dashing::BaseController

  def total_tests_run
    render json: {scenario_test_runs: ScenarioTestRun.all.map(&:browser_tests).map(&:count).sum,
                  feature_test_runs: FeatureTestRun.all.map(&:browser_tests).map(&:count).sum,
                  project_test_runs: ProjectTestRun.all.map(&:browser_tests).map(&:count).sum}
  end

  def total_minutes
    durations = {windows: 0, linux: 0, chrome: 0, firefox: 0, ie9: 0}
    [ScenarioTestRun, FeatureTestRun, ProjectTestRun].each do |tr|
      tr.all.each do |test_run|
        test_run.browser_tests.each do |browser_test|
          durations[browser_test.platform.to_sym] += browser_test.duration
          durations[browser_test.browser.to_sym] += browser_test.duration
        end
      end
    end

    render json: durations
  end
end
