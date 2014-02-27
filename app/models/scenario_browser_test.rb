class ScenarioBrowserTest

  include BrowserTest

  embedded_in :test_run, class_name: 'ScenarioTestRun'
  embeds_one :test_history, as: :test_runnable

  def run_all
    if TestSlot.find_available(platform, browser)
      driver
      status = run(test_run.scenario)
      if status == false
        self.update_attribute(:status, "fail")
      else
        self.update_attribute(:status, "pass")
      end
      self.test_run.reload.complete
      driver.quit
    else
      update_attribute(:retry_count, retry_count+1)
      if delay
        TestWorker.delay_for(delay).perform_async("run_test", "Scenario", test_run.id.to_s, self.id.to_s)
      else
        send_to_pusher("slot_unavailable", "No test slots currently available for #{platform} - #{browser}. Please try again later")
      end
    end
  end
end
