class ScenarioBrowserTest

  include BrowserTest

  belongs_to :scenario_test_run

  embeds_one :test_history, as: :test_runnable

  def test_run; scenario_test_run; end

  def channel_name
    "#{scenario_test_run.id}_#{platform}_#{browser}_channel"
  end

  def run_all
    create_test_history
    status = run(scenario_test_run.scenario)
    if status == false
      self.update_attribute(:status, "fail")
    else
      self.update_attribute(:status, "pass")
    end
    self.test_run.complete
  end

  def save_history(msg, status, id=nil)
    test_history.history_line_items.create({text: msg, status: status})
  end

end