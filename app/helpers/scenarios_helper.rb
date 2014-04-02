module ScenariosHelper

  def play_developer_mode_button(scenario)
    url = developer_mode_url(scenario)
    html = link_to(raw("#{glyph_button('play', "Play Developer Mode")}"), url, class: "btn btn-success btn-xs", target: "_blank")
    return html.html_safe
  end

  def developer_mode_url(scenario)
    join_char = scenario.steps.first.text.include?("?") ? "&" : "?"
    "#{scenario.steps.first.text}#{join_char}developer=true&scenario_id=#{scenario.id.to_s}"
  end

end
