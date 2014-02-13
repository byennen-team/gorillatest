class ProjectBrowserTest

  include BrowserTest

  embedded_in :project_test_run

  has_many :feature_browser_tests

  def test_run; project_test_run; end

  def run_all
    feature_browser_tests.each { |f| f.run_all }
  end

  def channel_name; end
end