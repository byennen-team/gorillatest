module ApplicationHelper
  #add active class to links
  def nav_link(link_text, link_path, italic_class)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_path do
        html = content_tag(:i, "", class: "fa fa-lg fa-fw #{italic_class}") + content_tag(:span, link_text, class: "menu-item-parent")
      end
    end
  end

  def user_nav_link(glyph_name, text, link, link_options={}, options={})
    link_to(user_nav_link_text(glyph_name, text), link, link_options)
  end

  def user_nav_link_text(glyph_name, text)
    html = "#{glyph(glyph_name)}&nbsp;#{text}"
    html.html_safe
  end

  def delete_glyph(options={})
    glyph("remove", options.merge!({style: "font-size: 1.8em; color: red"}))

  end

  def play_glyph(options={})
    glyph("play", options.merge!({style: "font-size: 1.8em;"}))
  end

  def record_glyph(options={})
    glyph("record", options.merge!({style: "font-size: 1.8em; color: red;"}))
  end

  def logout_glyph(options={})
     glyph("log-out", options)
  end

  def status_glyph(status, options={})
    if status == "pass"
      glyph("ok-sign", {class: "status status-pass"})
    else
      glyph("exclamation-sign", {class: "status status-fail"})
    end
  end

  def glyph(glyph_name, options={})
    if options[:class]
      options[:class] += " glyphicon glyphicon-#{glyph_name}"
    else
      options[:class] = " glyphicon glyphicon-#{glyph_name}"
    end
    html = content_tag(:span, "", options)
    html.html_safe
  end

  def duration_to_hours_minutes_seconds(duration)
    seconds = duration
    minutes = (seconds / 60) % 60
    hours = minutes / (60 * 60)
    duration_string = hours != 0 ? "#{hours}h" : ""
    duration_string += minutes == 0 ? " 0m" : " #{minutes}m"
    duration_string += " #{seconds}s"
    content_tag("span", duration_string, id: "duration").html_safe
  end

  def test_run_status(test_run)
    if test_run.status == "pass"
      html = content_tag(:span, "Passed", class:"label label-success", id: "test-run-status")
    elsif test_run.status == "fail"
      html = content_tag(:span, "Failed", class:"label label-danger", id: "test-run-status")
    else
      html = content_tag(:span, "Running", class:"label label-warning", id: "test-run-status")
    end

    return html.html_safe
  end

  def gravatar_image_tag(user, size=16)
    if user
      html = image_tag(user.gravatar_url(size))
      html.html_safe
    end
  end

  def play_button(testable)
    project = testable.is_a?(Project) ? testable : testable.project
    if project.creator.has_minutes_available?
      html = link_to play_glyph, "#", onclick: "$('#test_run-#{testable.id}').slideToggle()"
    else
      html = link_to play_glyph, edit_user_registration_path(anchor: "change-plan")
    end
    html.html_safe
  end
end
