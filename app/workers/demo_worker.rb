class DemoWorker

  include Sidekiq::Worker

  def perform(test_run_id, browser_test_id)
    test_run = ScenarioTestRun.find(test_run_id)
    browser_test = test_run.browser_tests.find(browser_test_id)
    scenario = test_run.scenario
    status = nil

    browser_test.initialize_test_history

    scenario.steps.each_with_index do |step, i|
      sleep(rand(0.8..3.2).round(1))
      if scenario.fail_step_num == (i += 1) && scenario.fail_browsers.include?("#{browser_test.platform}_#{browser_test.browser}")
        browser_test.save_history(step, step.to_s, "fail")
        # browser_test.update_attribute(:screenshot_filename, )
        Pusher.trigger(browser_test.channel_name, "step_pass", {status: "fail", text:"#{step.to_s}", scenario_id: scenario.id.to_s})
        status = "fail"
        break
      else
        browser_test.save_history(step, step.to_s, "pass")
        Pusher.trigger(browser_test.channel_name, "step_pass", {status: "pass", text:"#{step.to_s}", scenario_id: scenario.id.to_s})
      end
    end

    browser_test.update_attribute(:status, status || "pass")
    test_run.reload.complete
  end
end
