class Autotest.Models.Scenario extends Backbone.Model

  url: ->
    return "#{this.feature.url()}/scenarios/#{this.id}"

  initialize: (feature, scenarioId) ->
    console.log(feature.url())
    this.id = scenarioId
    this.feature = feature

  setCurrentScenario: ->
    console.log(this)
    Autotest.currentScenario = this
    window.sessionStorage.setItem("autoTestRecorder.currentScenario", this.id)

  feature: ->
    Autotest.currentFeature

  addStep: (stepAttributes) ->
    steps = new Autotest.Collections.Steps(this)
    _this = this
    steps.create(stepAttributes,
      success: (model, response, options) ->
        window.postMessageToIframe({messageType: "stepAdded", message: {stepCount: _this.steps().length} })
        # stepNumber = (@autoTestSteps.length).toString()
        # $("#autotest-view-steps ul").append("<li step-number=#{stepNumber}>#{autoTestStep.to_s}</li>")
      error: ->
        console.log("step could not be added")
    )

  steps: ->
    returnSteps = []
    currentSteps = new Autotest.Collections.Steps(this)
    currentSteps.fetch(
      async: false
      success: (c, r, o) ->
        returnSteps = c.models
      error: ->
        alert("Could not retrieve steps")
    )
    return returnSteps