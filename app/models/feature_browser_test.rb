class FeatureBrowserTest

  include BrowserTest

  belongs_to :feature

  embedded_in :test_run, class_name: 'FeatureTestRun'
  embeds_one :test_history

  def run_all
    #sleep 5 # this is to allow for the page refresh to finish so we don't lose Pusher messages.
    status = []
    test_run.feature.scenarios.each do |scenario|
      line_item = save_history("Running #{scenario.name}", nil, nil)
      status << run(scenario, line_item)
    end
    if status.include?(false)
      self.update_attribute(:status, "fail")
    else
      self.udpate_attribute(:status, "pass")
    end
    test_run.complete
  end

end