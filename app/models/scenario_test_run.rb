class ScenarioTestRun

  include TestRun

  field :window_x, type: Integer
  field :window_y, type: Integer
  field :start_url, type: String

  belongs_to :scenario

  has_many :browser_tests, class_name: 'ScenarioBrowserTest'

  def name
    scenario.name
  end

  def run
    update_attribute(:run_at, Time.now)
    scenario.feature.project.post_notifications(start_notification_message)
    browser_tests.each do |browser_test|
      browser_test = self.browser_tests.create!({browser: p.split('_').last,
                                                 platform: p.split('_').first})
      puts "Adding test"
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
    notification = "Test Run #{status}ed for #{self.project.name}- #{self.feature.name} - #{self.scenario.name} - #{number}:"
    url = project_feature_scenario_test_run_url(project, feature, scenario, self, host: ENV['API_URL'])
    notification += " "
    notification += url
  end

  private

  def copy_scenario_values
    self.window_x = scenario.window_x
    self.window_y = scenario.window_y
    self.start_url = scenario.start_url
    scenario.steps.each { |step| steps << Step.new(step.attributes.except("_id").except("updated_at").except("created_at")) }
  end

  def set_number
    self.number = scenario.test_runs.size + 1
  end

end
