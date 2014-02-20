class ScenarioBrowserTest

  include BrowserTest

  embedded_in :test_run, class_name: 'ScenarioTestRun'
  embeds_one :test_history, as: :test_runnable

  def run_all
    status = run(test_run.scenario)
    if status == false
      self.update_attribute(:status, "fail")
    else
      self.update_attribute(:status, "pass")
    end
    self.test_run.complete
  end

end
