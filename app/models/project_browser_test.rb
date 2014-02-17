class ProjectBrowserTest

  include BrowserTest

  embedded_in :project_test_run
  embeds_one :test_history

  def test_run; project_test_run; end

  def channel_name
    "#{test_run.id}_#{platform}_#{browser}_channel"
  end

  def run_all
    Rails.logger.debug("running all")
    create_test_history
    sleep 5 # this is to allow for the page refresh to finish so we don't lose Pusher messages.
    test_run.project.features.each do |feature|
      send_to_pusher('play_feature', {feature_id: feature.id.to_s, feature_name: feature.name})
      feature_line_item = save_history("Feature: #{feature.name}", nil)
      feature.scenarios.each do |scenario|
        line_item = save_history("Running #{scenario.name}", nil, feature_line_item)
        run(scenario, line_item)
      end
    end
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