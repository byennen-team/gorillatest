module TestRun
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
    include Mongoid::Document
    include Mongoid::Timestamps
    include TestDuration

    field :number, type: Integer # don't use anymore, but keeping it because not sure about old data
    field :timestamp, type: String
    field :platforms, type: Array

    belongs_to :user

    # embeds_many :browser_tests

    after_create :set_timestamp
  end

  def set_timestamp
    update_attribute(:timestamp, created_at.strftime("%b %d, %I:%M %p %Z"))
  end

  def complete
    return if status == "running"
    message = create_message_and_url
    project.project_users.map(&:user).each do |user|
      user.messages.create(message)
      if status == "fail" || (status == "pass" && project.email_notification == "success")
        UserMailer.delay.notify_test_result(user.id.to_s, self.class.to_s.underscore, self.id)
      end
    end
    channel_name = browser_tests.first.channel_name
    pusher_return = Pusher.trigger([channel_name], "test_run_complete", {status: status})
    update_attribute(:completed_at, Time.now)
    deduct_seconds_used unless project.demo_project?
    send_complete_notification
  end

  def status
    test_statuses = browser_tests.map(&:status)
    status = "running"
    if !test_statuses.include?(nil)
     status = test_statuses.include?("fail") ? "fail" : "pass"
    end
    return status
  end

  def send_complete_notification
    project.post_notifications(complete_notification_message)
  end

  def total_duration
    browser_tests.sum(&:duration)
  end

  def deduct_seconds_used
    allowance = project.creator.current_allowance
    allowance.seconds_used += total_duration
    allowance.save
  end

  def create_message_and_url
    message = {}
    if self.kind_of?(ScenarioTestRun)
     message[:message] = "#{project.name} - #{name} test run #{status}ed"
     message[:url] = url_for(project_test_test_run_path(project, scenario.slug, self))
    else
      message[:message] = "#{name} test run #{status}ed"
      message[:url] = url_for(project_test_run_path(project, self))
    end
    return message
  end

end
