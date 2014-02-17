class ProjectTestRun

  include TestRun

  belongs_to :project
  embeds_many :browser_tests, class_name: 'ProjectBrowserTest'

  def feature; nil; end

  def name
    project.name
  end

  def run
    update_attribute(:run_at, Time.now)
    puts "\n\n\n\n\n\n\nPUtting NOtifications\n\n\n\n\n\n\n\n\n\n"
    project.post_notifications(start_notification_message)
    browser_test.each do |browser_test|
      TestWorker.perform_async("run_test", "Project", self.id.to_s, browser_test.id.to_s)
    end
  end

  def start_notification_message
    notification = "Test Run Started For: "
    notification += "#{self.project.name} - #{self.number}"
    url = project_test_run_url(project, self, host: ENV["API_URL"])
    notification += " "
    notification += url
  end

  def complete_notification_message
    notification = "Test Run #{status}ed for #{self.project.name} - #{number}:"
    url = project_test_run_url(project, self, host: ENV['API_URL'])
    notification += " "
    notification += url
  end

  private

  def set_number
    self.number = project.test_runs.size + 1
  end

end