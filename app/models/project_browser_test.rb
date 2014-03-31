class ProjectBrowserTest

  include BrowserTest

  embedded_in :test_run, class_name: 'ProjectTestRun'
  embeds_one :test_history

  def run_all
    driver
    #sleep 5 # this is to allow for the page refresh to finish so we don't lose Pusher messages.
    status = []
    set_ran_at_time
    test_run.project.scenarios.each do |scenario|
        line_item = save_history(scenario, "Running Test: #{scenario.name}", nil, nil)
        status << run(scenario, line_item)
      end
    end
    if status.include?(false)
      self.update_attribute(:status, "fail")
    else
      self.update_attribute(:status, "pass")
    end
    self.test_run.reload.complete
    @driver = driver.quit
  end

end
