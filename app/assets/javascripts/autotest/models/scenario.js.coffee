class Autotest.Models.Scenario extends Backbone.Model

  url: ->
    return this.instanceUrl

  initialize: (options) ->
    this.instanceUrl = options.url || null

  setCurrentScenario: ->
    console.log(this)
    console.log("Id is #{this.get("id")}")
    Autotest.currentScenario = this
    window.sessionStorage.setItem("autoTestRecorder.currentScenario", this.get("id"))

  feature: ->
    Autotest.currentFeature

  addStep: (stepAttributes) ->
    debugger
    steps = Autotest.currentSteps
    _this = this
    console.log("adding step #{stepAttributes}")
    steps.create(stepAttributes,
      success: (model, response, options) ->
        Autotest.Messages.Parent.post({messageType: "stepAdded", message: {stepCount: _this.steps().length} })
        # stepNumber = (@autoTestSteps.length).toString()
        # $("#autotest-view-steps ul").append("<li step-number=#{stepNumber}>#{autoTestStep.to_s}</li>")
      error: ->
        console.log("step could not be added")
    )

  steps: ->
    returnSteps = []
    if Autotest.currentSteps != null
      currentSteps = new Autotest.Collections.Steps(this)
      Autotest.currentSteps = currentSteps
    else
      currentSteps = Autotest.currentSteps
    currentSteps.fetch(
      async: false
      success: (c, r, o) ->
        # returnSteps = c.models
      error: ->
        console.log("Could not retrieve steps")
    )
    return currentSteps
