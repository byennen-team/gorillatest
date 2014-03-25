class Autotest.Models.Scenario extends Backbone.Model

  setCurrentScenario: ->
    Autotest.currentScenario = this
    window.sessionStorage.setItem("autoTestRecorder.currentScenario", this.id)

  feature: ->
    Autotest.currentFeature

  addStep: (stepAttributes) ->
    steps = new Autotest.Collections.Steps(this)
    steps.create(stepAttributes,
      success: ->
      error: ->
    )

  steps: ->
    steps = new Autotest.Collections.Steps(this)
    steps.fetch()
    return steps.models
