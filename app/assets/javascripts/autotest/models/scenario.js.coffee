class Autotest.Models.Scenario extends Backbone.Model

  urlRoot : "#{Autotest.apiUrl}/api/v1/scenarios"

  setCurrentScenario: ->
    Autotest.currentScenario = this
    window.sessionStorage.setItem("autoTestRecorder.currentScenario", this.get("id"))

  addStep: (stepAttributes) ->
    steps = Autotest.currentSteps
    _this = this
    steps.create(stepAttributes,
      success: (model, response, options) ->
        Autotest.Messages.Parent.post({messageType: "stepAdded", message: {stepCount: _this.steps().length} })
        # stepNumber = (@autoTestSteps.length).toString()
        # $("#autotest-view-steps ul").append("<li step-number=#{stepNumber}>#{autoTestStep.to_s}</li>")
      error: ->
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
      )
    else
      currentSteps = Autotest.currentSteps
    return currentSteps
