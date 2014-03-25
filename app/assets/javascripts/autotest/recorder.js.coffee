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
    if @isRecording == true
      # load the current scenario
      scenarioId = @sessionStorage.getItem("autoTestRecorder.currentScenario")
      featureId = @sessionStorage.getItem("autoTestRecorder.currentFeature")
      options = new Array
      if featureId != null
        Autotest.currentFeature = Autotest.features.findWhere({id: featureId})
        # Figure out where to move this!!!
        $("select#features").val(featureId)
      if scenarioId != null
        scenarios = Autotest.Collections.Scenarios(Autotest.currentFeature)
        Autotest.currentScenario = scenarios.findWhere({id: scenarioId})
        # @currentScenario = AutoTestScenario.find(@projectId, @currentFeature.id, scenarioId)
      # Record step of redirected to -> current window location href
      $("iframe").load ->
        window.postMessageToIframe({messageType: "recording", recording: _this.isRecording, message: {scenarioName: Autotest.currentScenario.get('name'), featureName: Autotest.currentFeature.get('name')}})
        step = Autotest.currentScenario.addStep({event_type: "waitForCurrentUrl", locator_type: '', locator_value: '', text: window.location.href})
      $.each(Autotest.currentScenario.steps(), (i, step) ->
        console.log(i)
        $("ul#autotest-steps").append("<li step-number=#{i}>#{step.get('to_s')}</li>")
      )

      this.record()
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
