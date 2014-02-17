module TestRun

  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
    include Mongoid::Document
    include Mongoid::Timestamps

    field :queued_at, type: DateTime
    field :ran_at, type: DateTime
    field :number, type: Integer
    field :platforms, type: Array

    belongs_to :user

    # embeds_many :browser_tests

    before_create :set_number
  end

  def complete(current_step=nil)
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
    send_complete_notification
  end

  def duration
    ran_at.nil? ? 0 : browser_tests.last.updated_at - ran_at
  end

  def status
    test_statuses = browser_tests.map(&:status)
    status = "running"
    Rails.logger.debug("statuses are #{test_statuses}")
    if !test_statuses.include?(nil)
     status = test_statuses.include?("fail") ? "fail" : "pass"
    end
    return status
  end

  def send_complete_notification
    project.post_notifications(complete_notification_message)
  end

end