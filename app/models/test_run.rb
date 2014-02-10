require 'net/http'

class UrlInaccessible < Exception; end

class TestRun

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
    browser_tests.last.updated_at - ran_at
  end

  def fail!
    update_attribute("status", "fail")
  end

  def pass!
    update_attribute("status", "pass")
  end

  private

  def save_window_size_and_url
    self.window_x = scenario.window_x
    self.window_y = scenario.window_y
    self.start_url = scenario.start_url
  end
end
