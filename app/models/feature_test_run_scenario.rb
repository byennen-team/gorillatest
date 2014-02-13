class FeatureTestRunScenario

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :window_x, type: Integer
  field :window_y, type: Integer
  field :start_url, type: String

  belongs_to :scenario

  embeds_many :steps

  embedded_in :feature_test_run
  embedded_in :feature_browser_test

  before_create :save_steps

  private

  def save_steps
    self.name = scenario.name
    self.window_x = scenario.window_x
    self.window_y = scenario.window_y
    self.start_url = scenario.start_url
    scenario.steps.each { |step| steps << Step.new(step.attributes.except("_id").except("updated_at").except("created_at")) }
  end

end