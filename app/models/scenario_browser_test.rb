class ScenarioBrowserTest

  include BrowserTest

  belongs_to :feature_browser_test
  belongs_to :scenario_test_run
  # embedded_in :scenario_test_run
  embeds_many :steps

  before_create :copy_steps

  def test_run; scenario_test_run; end

  def channel_name
    "#{scenario_test_run.id}_#{platform}_#{browser}_channel"
  end

  def run_all
    run(self)
  end

  private

  def copy_steps
    steps << scenario_test_run.steps #.each do { |s| steps << s }
  end

end