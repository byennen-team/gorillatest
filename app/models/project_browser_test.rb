class ProjectBrowserTest

  include BrowserTest

  embedded_in :test_run, class_name: 'ProjectTestRun'
  embeds_one :test_history

  def run_all
    driver
    #sleep 5 # this is to allow for the page refresh to finish so we don't lose Pusher messages.
    status = []
    set_ran_at_time
    test_run.project.scenarios.each_with_index do |scenario, index|
      line_item = save_history(scenario, "#{scenario.name}", nil, nil)
      status << run(scenario, line_item)
      Pusher.trigger([channel_name], "scenario_complete", {platform: platform, browser: browser, num_scenarios_completed: index+1})
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
