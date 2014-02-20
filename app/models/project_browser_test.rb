class ProjectBrowserTest

  include BrowserTest

  embedded_in :test_run, class_name: 'ProjectTestRun'
  embeds_one :test_history

  def run_all
    #sleep 5 # this is to allow for the page refresh to finish so we don't lose Pusher messages.
    status = []
    test_run.project.features.each do |feature|
      send_to_pusher('play_feature', {feature_id: feature.id.to_s, feature_name: feature.name})
      feature_line_item = save_history("Feature: #{feature.name}", nil)
      feature.scenarios.each do |scenario|
        line_item = save_history("Running #{scenario.name}", nil, feature_line_item)
        status << run(scenario, line_item)
      end
    end
    if status.include?(false)
      self.update_attribute(:status, "fail")
    else
      self.update_attribute(:status, "pass")
    end
    self.test_run.complete
  end

end