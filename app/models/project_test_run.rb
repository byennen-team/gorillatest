class ProjectTestRun

  include TestRun

  belongs_to :project

  def feature; nil; end

  def start_notification_message
    notification = "Test Run Started For: "
    notification += "#{self.project.name} - #{self.number}"
    url = project_test_run_url(project, self, host: ENV["API_URL"])
    notification += " "
    notification += url
  end

  def complete_notification_message
    notification += "Test Run #{status}ed for #{self.project.name} - #{number}:"
    url = project_test_run_url(project, self, host: ENV['API_URL'])
    notification += " "
    notification += url
  end

end