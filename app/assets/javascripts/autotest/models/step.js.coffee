class Autotest.Models.Step extends Backbone.Model

  scenario: ->
    Autotest.currentScenario

  feature: ->
    Autotest.currentFeature

  element: ->
    switch @get("locator_type")
      when "id"
        return $("##{@get("locator_value")}")
      when "name"
        return $("input[name='#{@get("locator_value")}'")
      when "link"
        return $("a:contains('#{@get('locator_value')}')")
      when "xpath"
        return $.xpath(@get("locator_value"))

  perform: ->
    Autotest.Developer.Steps.perform(this)