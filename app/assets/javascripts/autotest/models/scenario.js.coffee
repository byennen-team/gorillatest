class Autotest.Models.Scenario extends Backbone.Model

  urlRoot : "#{Autotest.apiUrl}/api/v1/scenarios"

  setCurrentScenario: ->
    Autotest.currentScenario = this
    window.sessionStorage.setItem("autoTestRecorder.currentScenario", this.get("id"))

  addStep: (stepAttributes) ->
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
    if Autotest.currentSteps == null
      this.instanceUrl = "/scenarios/#{this.id}"
      currentSteps = new Autotest.Collections.Steps(this)
      currentSteps.fetch(
        async: false
        success: (c, r, o) ->
          Autotest.currentSteps = currentSteps
        error: ->
          console.log("Could not retrieve steps")
      )
    else
      currentSteps = Autotest.currentSteps
    return currentSteps
