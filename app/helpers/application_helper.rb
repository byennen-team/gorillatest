module ApplicationHelper
  #add active class to links
  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def delete_glyph
    Rails.logger.debug(content_tag(:span, class: "glyphicon"))
    raw(content_tag(:span, "", {class: "glyphicon glyphicon-remove", style: "font-size: 1.8em; color: red"}))

  end

  def play_glyph
    raw(content_tag(:span, "", {class: "glyphicon glyphicon-play", style: "font-size: 1.8em;"}))
  end

end
