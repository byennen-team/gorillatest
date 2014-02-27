module TestRun

  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
    include Mongoid::Document
    include Mongoid::Timestamps

    field :queued_at, type: DateTime
    field :ran_at, type: DateTime
    field :completed_at, type: DateTime
    field :number, type: Integer
    field :platforms, type: Array

    belongs_to :user

    # embeds_many :browser_tests

    before_create :set_number
  end

  def complete
    return if status == "running"
    if status == "fail"
      project.project_users.map(&:user_id).map(&:to_s).each do |member_id|
        UserMailer.delay.notify_failed_test(member_id, self.class.to_s.underscore, self.id)
      end
    elsif status == "pass" && project.email_notification == "success"
      project.project_users.map(&:user_id).map(&:to_s).each do |member_id|
        UserMailer.delay.notify_successful_test(member_id, self.class.to_s.underscore, self.id)
      end
    end
    channel_name = browser_tests.first.channel_name
    pusher_return = Pusher.trigger([channel_name], "test_run_complete", {status: status})
    update_attribute(:completed_at, Time.now)
    send_complete_notification
  end

  def duration
    if ran_at.nil?
      return 0
    elsif completed_at.nil?
      return Time.now.to_i - ran_at.to_i
    else
      return completed_at.to_i - ran_at.to_i
    end
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

end
