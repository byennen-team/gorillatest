class Autotest.Models.Step extends Backbone.Model


  scenario: ->
    Autotest.currentScenario

  feature: ->
    Autotest.currentFeature

  element: ->
    switch locator_type
      when "id"
        return $("##{locator_value}")
      when "name"
        return $("input[name='#{locator_value}'")
      when "xpath"
        return $.xpath(locator_value)

  perform: ->
    console.log(this.get("text"))
    return false