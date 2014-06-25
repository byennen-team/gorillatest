module DashboardHelper

  def test_run_status_class(test_run_status)
    if test_run_status == "pass"
      return "passing"
    elsif test_run_status == "fail"
      return "failing"
    else
      return "running"
    end
  end

  def bang_or_check(test_run_status)
    if test_run_status == "pass"
      return "fa-check"
    elsif test_run_status == "fail"
      return "fa-exclamation"
    else
      return "fa-ellipsis-h"
    end
  end

  def status_color(status)
    if status == "pass"
      return "alert-success"
    elsif status == "fail"
      return "alert-danger"
    else
      return "alert-info"
    end
  end

  def test_run_link_class(test_run_status)
    if test_run_status == "pass"
      return "txt-color-greenDark"
    elsif test_run_status == "fail"
      return "txt-color-red"
    else
      return "txt-color-yellow"
    end
  end

  def test_run_name(test_run)
    name = test_run.project.name
    if test_run.class == ScenarioTestRun
      name += "- #{test_run.scenario.name}"
    end
    html = content_tag(:strong, name)
    return html.html_safe
  end

  def test_run_link(test_run)
    if test_run.class == ScenarioTestRun
      return project_test_test_run_path(test_run.project, test_run.scenario.slug, test_run)
    else
      return project_test_run_path(test_run.project, test_run)
    end
  end

  def test_run_platforms(test_run)
    string = content_tag(:strong, "Platforms: ")
    string += test_run.platforms.map { |p| p.humanize.titleize }.join(', ')
    return string
  end

end
