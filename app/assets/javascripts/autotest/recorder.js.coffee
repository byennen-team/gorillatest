class @AutoTestRecorder
  constructor: (@projectId) ->
    @authToken = window.autoTestAuthToken
    if window.sessionStorage
      @sessionStorage = window.sessionStorage
    else
      alert("You can't record on this browser")
    @isRecording = @sessionStorage.getItem("autoTestRecorder.isRecording") == "true" ? true : false
    @currentScenario = null
    @currentFeature = null
    @features = new Array

  start: ->
    # # @features = AutoTestFeature.findAll(@projectId)
    # @features = new Autotest.Collections.Features
    # @features.fetch()
    _this = this
    console.log("is recording is #{@isRecording}")
    if @isRecording == true
      # load the current scenario
      scenarioId = @sessionStorage.getItem("autoTestRecorder.currentScenario")
      featureId = @sessionStorage.getItem("autoTestRecorder.currentFeature")
      options = new Array
      if featureId != null
        feature = Autotest.features.findWhere({id: featureId})
        feature.setCurrentFeature()
        # Figure out where to move this!!!
        $("select#features").val(featureId)
      if scenarioId != null
        _this = this
        scenario = new Autotest.Models.Scenario(feature, scenarioId)
        scenario.fetch(
          success: (model, response, options) ->
            Autotest.currentScenario = model
            $.each(Autotest.currentScenario.steps(), (i, step) ->
              $("ul#autotest-steps").append("<li step-number=#{i}>#{step.get('to_s')}</li>")
            )
            $("iframe").load ->
              console.log("iframe loaded")
              window.postMessageToIframe({messageType: "recording", recording: _this.isRecording, message: {scenarioName: Autotest.currentScenario.get('name'), featureName: Autotest.currentFeature.get('name')}})
              step = Autotest.currentScenario.addStep({event_type: "waitForCurrentUrl", locator_type: '', locator_value: '', text: window.location.href})
            _this.record()
            return
        )
    else
      # Figure out where to move this
      $("button#stop-recording").hide()
      $("button#record-text-highlight").hide()

  record: ->
    console.log("We are currently recording")
    # Collect actions to a JSON structure
    @isRecording = true
    @sessionStorage.setItem("autoTestRecorder.isRecording", @isRecording)
    console.log("Binding DOM events")
    AutoTestEvent.bind()
    AutoTestEvent.bindDomNodeInsert()
    return

  stop: ->
    @isRecording = false
    @sessionStorage.setItem("autoTestRecorder.isRecording", false)
    @sessionStorage.removeItem("autoTestRecorder.currentFeature")
    @sessionStorage.removeItem("autoTestRecorder.currentScenario")
    Autotest.currentFeature = null
    Autotest.currentScenario = null
    # Unbind all events
    autoTestGuiController.removeStepsList()
    AutoTestEvent.unbind()
    # This is a temporary hack to reload the page and kill all the bindings. - jkr
    window.location.href = window.location.href

  recordHighlight: (text)->
    scenario = this.currentScenario
    stepLocator = {type: "text highlight on page", value: window.location.pathname}
    scenario.addStep("Highlight Text", stepLocator, text)
