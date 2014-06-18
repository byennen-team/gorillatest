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
    update_attribute(:ran_at, Time.now)
    scenario.project.post_notifications(start_notification_message)
    browser_tests.each do |browser_test|
      TestWorker.perform_async("run_test", "Scenario", self.id.to_s, browser_test.id.to_s)
    end
  end

  def project
    scenario.project
  end

  def start_notification_message
    notification = "Test Run started for "
    notification += "#{self.project.name} - #{self.scenario.name} - #{timestamp}:"
    url = project_test_test_run_url(project, scenario.slug, self, host: ENV["API_URL"])
    notification += " "
    notification += url
  end

  def complete_notification_message
    notification = "Test Run #{status}ed for #{self.project.name} - #{self.scenario.name} - #{timestamp}:"
    url = project_test_test_run_url(project, scenario.slug, self, host: ENV['API_URL'])
    notification += " "
    notification += url
  end
end
