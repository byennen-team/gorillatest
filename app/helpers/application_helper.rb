module ApplicationHelper
  #add active class to links
  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
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
    seconds = duration.ceil % 60
    minutes = (seconds / 60) % 60
    hours = minutes / (60 * 60)
    duration_string = hours != 0 ? "#{hours}h" : ""
    duration_string += minutes == 0 ? " 0m" : " #{minutes}m"
    duration_string += " #{seconds}s"
    duration_string.html_safe
  end

end
