class FeatureBrowserTest

  include BrowserTest

  embedded_in :feature_test_run
  embeds_many :scenarios, class_name: 'FeatureTestRunScenario'

  belongs_to :project_browser_test

  has_many :scenario_browser_test

  before_create :create_scenarios

  def test_run; feature_test_run; end

  def channel_name
    "#{feature_test_run.id}_#{platform}_#{browser}_channel"
  end

  def run_all
    scenarios.each do |scenario|
      send_to_pusher("event_type", message)
      run(scenario)
    end
  end

  private

  def create_scenarios
    test_run.scenarios.each do |scenario|
      scenarios << FeatureTestRunScenario.new(scenario: scenario)
    end
  end

end