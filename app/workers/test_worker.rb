class TestWorker

  include Sidekiq::Worker

  sidekiq_options :retry => false, :backtrace => true

  def perform(method, *args)
    self.send(method, *args)
    # TestRun.find(test_run_id)
  end

  def queue_tests(test_run_type, test_run_id)
    case test_run_type
    when 'Scenario'
      ScenarioTestRun.find(test_run_id).run
    when 'Feature'
      FeatureTestRun.find(test_run_id).run
    when 'Project'
      ProjectTestRun.find(test_run_id).run
    end
  end

  def run_test(test_run_type, test_run_id, test_id)
    case test_run_type
    when 'Scenario'
      scenario_test_run = ScenarioTestRun.find(test_run_id)
      scenario_test_run.browser_tests.find(test_id).run_all
    when 'Feature'
      FeatureTestRun.find(test_run_id).browser_tests.find(test_id).run_all
    when 'Project'
      ProjectTestRun.find(test_run_id).browser_tests.find(test_id).run_all
    end
  end

end
