class Autotest.Models.Step extends Backbone.Model


  scenario: ->
    Autotest.currentScenario

  feature: ->
    Autotest.currentFeature