module ApplicationHelper
  #add active class to links
  def nav_link(link_text, link_path, italic_class)
    class_name = current_page?(link_path) ? 'active' : ''
    if link_text == "Projects" && projects_controller?(params[:controller])
      class_name = 'active'
    end
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

  def projects_controller?(controller)
    %w(projects scenarios test_runs project_test_runs).include?(controller)
  end

  def current_project?(project)
    params[:project_id] == project.slug || params[:id] == project.slug
  end

  def delete_glyph(options={})
    glyph_button("remove", "Delete")

  end

  def play_glyph(options={})
    glyph_button("play", options[:text] || "Play")
  end

  def record_glyph(options={})
    glyph_button("record", "Record")
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

  def glyph_button(glyph_name, text, options={})
    html = glyph(glyph_name, options)
    html += " #{text}"
    html.html_safe
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

  def play_button(testable, text=nil)
    Rails.logger.debug("rendering play button")
    project = testable.is_a?(Project) ? testable : testable.project
    if project.creator.has_minutes_available?
      html = link_to play_glyph(text: text), "javascript:void(0)", onclick: "$('#test_run-#{testable.id}').slideToggle();", class: "btn btn-success btn-xs"
    else
      html = link_to play_glyph(text: text), edit_user_registration_path(anchor: "change-plan"), class: "btn btn-success btn-xs"
    end
    html.html_safe
  end

  def pape_title(title, icon)
    content_tag(:div, class: 'col-xs-12 col-sm-7 col-md-11 col-lg-8') do
      content_tag(:h1, class: 'page-title txt-color-blueDark') do
        content_tag(:i, "", class: "fa fa-fw #{icon}") + title
      end
    end
  end

  def form_title(title, icon)
    content_tag(:section, id: 'widget-grid') do
      content_tag(:div, class: 'row') do
        content_tag(:article, class: 'col-sm-12.col-md-8.col-lg-20') do
          content_tag(:header) do
            content_tag(:span, class: 'widget-icon') do
              content_tag(:i, "", class: "fa #{icon}") + content_tag(:h2, title)
            end
          end
        end
      end
    end
  end

  #bootstrap flash messages
  def bootstrap_class_for(flash_type)
    case flash_type
    when "success"
      "alert-success"   # Green
    when "error"
      "alert-danger"    # Red
    when "alert"
      "alert-warning"   # Yellow
    when "notice"
      "alert-info"      # Blue
    else
      flash_type.to_s
    end
  end
end
