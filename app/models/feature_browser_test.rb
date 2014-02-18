class FeatureBrowserTest

  include BrowserTest

  belongs_to :feature

  embedded_in :feature_test_run
  embeds_one :test_history

  def test_run; feature_test_run; end

  def channel_name
    "#{feature_test_run.id}_#{platform}_#{browser}_channel"
  end

  def run_all
    create_test_history
    sleep 5 # this is to allow for the page refresh to finish so we don't lose Pusher messages.
    status = []
    feature_test_run.feature.scenarios.each do |scenario|
      line_item = save_history("Running #{scenario.name}", nil, nil)
      status << run(scenario, line_item)
    end
    if status.include?(false)
      self.update_attribute(:status, "fail")
    else
      self.udpate_attribute(:status, "pass")
    end
    self.test_run.complete
  end

  private

  def save_history(msg, status, line_item=nil)
    if line_item.nil?
      line_item = test_history.history_line_items.create({text: msg, status: status, parent: id})
      return line_item
    else
      child = line_item.children.create({text: msg, status: status})
      return child
    end
  end

end