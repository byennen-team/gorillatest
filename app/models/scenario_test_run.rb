class ScenarioTestRun

  include TestRun

  field :window_x, type: Integer
  field :window_y, type: Integer
  field :start_url, type: String

  belongs_to :scenario

  embeds_many :browser_tests, class_name: 'ScenarioBrowserTest'

  def name
    scenario.name
  end

  def run
    update_attribute(:run_at, Time.now)
    scenario.feature.project.post_notifications(start_notification_message)
    browser_tests.each do |browser_test|
      TestWorker.perform_async("run_test", "Scenario", self.id.to_s, browser_test.id.to_s)
    end
  end

  def project
    feature.project
  end

  def feature
    scenario.feature
  end

  def start_notification_message
    notification = "Test Run started for "
    notification += "#{self.project.name} - #{self.feature.name} - #{self.scenario.name} - #{number}:"
    url = project_feature_scenario_test_run_url(project, feature, scenario, self, host: ENV["API_URL"])
    notification += " "
    notification += url
  end

  def complete_notification_message
    notification = "Test Run #{status}ed for #{self.project.name} - #{self.feature.name} - #{self.scenario.name} - #{number}:"
    url = project_feature_scenario_test_run_url(project, feature, scenario, self, host: ENV['API_URL'])
    notification += " "
    notification += url
  end

  private

  def set_number
    if scenario.test_runs.include?(self)
      self.number = scenario.test_runs.size
    else
      self.number = scenario.test_runs.size + 1
    end
  end

end
