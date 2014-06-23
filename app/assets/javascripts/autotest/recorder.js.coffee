class @AutoTestRecorder
  constructor: (@projectId) ->
    @authToken = window.autoTestAuthToken
    if window.sessionStorage
      @sessionStorage = window.sessionStorage
    else
      alert("You can't record on this browser")
    @isRecording = @sessionStorage.getItem("autoTestRecorder.isRecording") == "true" ? true : false
    @currentFeature = null
    @features = new Array

  start: ->
    _this = this
    console.log("is recording is #{@isRecording}")
    if @isRecording == true
      # load the current scenario
      scenarioId = @sessionStorage.getItem("autoTestRecorder.currentScenario")
      options = new Array
      if scenarioId != null
        _this = this
        scenario = new Autotest.Models.Scenario({id: scenarioId})
        scenario.setCurrentScenario()
        stepsView = new Autotest.Views.StepIndex({collection: Autotest.currentScenario.steps()})
        scenario.fetch
          success: (model, response, options) ->
            if response.project_id == Autotest.projectId
              $("#gt-loading-overlay").hide()
              Autotest.Messages.Parent.post({messageType: "recording", recording: _this.isRecording, message: {scenarioName: Autotest.currentScenario.get('name')}})
              step = Autotest.currentScenario.addStep({event_type: "waitForCurrentUrl", locator_type: '', locator_value: '', text: window.location.href})
              _this.record()
          error: ->
            alert("Could not start recorder")

  record: ->
    console.log("We are currently recording")
    # Collect actions to a JSON structure
    @isRecording = true
    @sessionStorage.setItem("autoTestRecorder.isRecording", @isRecording)
    console.log("Binding DOM events")
    Autotest.Event.bind()
    Autotest.Event.bindDomNodeInsert()
    return

  stop: ->
    $.ajax
      url: "#{Autotest.apiUrl}/api/v1/scenarios/#{Autotest.currentScenario.get("id")}/publish"
      data: {id: Autotest.currentScenario.get("id"), scenario: {completed: true}}
      method: "POST"

    @isRecording = false
    @sessionStorage.setItem("autoTestRecorder.isRecording", false)
    @sessionStorage.removeItem("autoTestRecorder.currentFeature")
    @sessionStorage.removeItem("autoTestRecorder.currentScenario")
    @sessionStorage.removeItem("autoTest.showRecorder")
    # Autotest.currentFeature = null
    # Autotest.currentScenario = null
    # Autotest.currentSteps = null
    options = {width: "400px", height: "400px", margin: "0 auto", "overflow-y": "auto", wrapperId: 'scenario-modal'}
    autoTestGuiController.removeStepsList()
    Autotest.Event.unbind()
    Autotest.Event.unbindDomNodeInsert()
    autoTestGuiController.stopElementHighlight()
    autoTestGuiController.renderModal("test_complete_modal", options)
    Autotest.currentFeature = null
    Autotest.currentScenario = null
    Autotest.currentSteps = null


  recordHighlight: (text)->
    scenario = this.currentScenario
    stepLocator = {type: "text highlight on page", value: window.location.pathname}
    scenario.addStep("Highlight Text", stepLocator, text)
