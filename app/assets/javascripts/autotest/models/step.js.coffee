class Autotest.Models.Step extends Backbone.Model


  scenarion: ->
    Autotest.currentScenario

  feature: ->
    Autotest.currentFeature

  to_s: ->
