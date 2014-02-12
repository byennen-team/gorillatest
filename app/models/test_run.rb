require 'net/http'

class UrlInaccessible < Exception; end

class TestRun
  include Rails.application.routes.url_helpers

  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :current_step, :channel_name

  field :window_x, type: Integer
  field :window_y, type: Integer
  field :start_url, type: String
  field :queued_at, type: DateTime
  field :ran_at, type: DateTime
  field :number, type: Integer

  belongs_to :scenario
  belongs_to :user

  embeds_many :browser_tests
  embeds_many :steps

  before_create :save_window_size_and_url

  def run
    update_attribute(:ran_at, Time.now)
    project.post_notifications("Test Run started for #{self.scenario.name}-#{number}: #{project_feature_scenario_test_run_url(project, feature, scenario, self, host: ENV['API_URL'])}")
    browser_tests.each do |test|
      test.queued_at = Time.now
      test.steps << steps
      test.save
      TestWorker.perform_async("run_test", self.id.to_s, test.id.to_s)
    end
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

  def duration
    ran_at.nil? ? 0 : browser_tests.last.updated_at - ran_at
  end

  def fail!
    update_attribute("status", "fail")
  end

  def pass!
    update_attribute("status", "pass")
  end

  def complete
    return if status == "running"
    if status == "fail"
      project.project_users.map(&:user_id).map(&:to_s).each do |member_id|
        UserMailer.delay.notify_failed_test(member_id, current_step ,self.id)
      end
    elsif status == "pass" && project.email_notification == "success"
      project.project_users.map(&:user_id).map(&:to_s).each do |member_id|
        UserMailer.delay.notify_successful_test(member_id, self.id)
      end
    end
    send_complete_notifications
  end

  def project
    scenario.feature.project
  end

  def feature
    scenario.feature
  end

  def platforms_ran
    browser_tests.map(&:platform).uniq
  end

  def platforms_browsers_statuses
    statuses = {}
    platforms_ran.each {|p| statuses[p.to_s.capitalize] = {}}

    browser_tests.each do |browser_test|
      status = {browser_test.browser.capitalize => browser_test.status}
      statuses[browser_test.platform.capitalize].merge!(status)
    end

    statuses
  end

  private

  def send_complete_notifications
    project.post_notifications("Test Run #{status}ed for #{self.scenario.name}-#{number}: #{project_feature_scenario_test_run_url(project, feature, scenario, self, host: ENV['API_URL'])}")
  end

  def save_window_size_and_url
    self.window_x = scenario.window_x
    self.window_y = scenario.window_y
    self.start_url = scenario.start_url
  end

end
