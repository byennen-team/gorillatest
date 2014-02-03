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

  def logout_glyph(options={})
     glyph("log-out", options)
  end

  def glyph(glyph_name, options={})
    html = content_tag(:span, "", {class: "glyphicon glyphicon-#{glyph_name}"}.merge!(options))
    html.html_safe
  end

end
