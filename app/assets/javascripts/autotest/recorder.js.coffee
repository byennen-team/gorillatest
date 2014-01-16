class @AutoTestRecorder
  constructor: (@projectId) ->
    @authToken = window.autoTestAuthToken
    @baseUrl = window.autoTestApiUrl + "/scenarios"
    if window.sessionStorage
      @sessionStorage = window.sessionStorage
    else
      alert("You can't record on this browser")
    @isRecording = @sessionStorage.getItem("autoTestRecorder.isRecording") == "true" ? true : false
    @currentScenario = null
    @currentFeature = null
    @features = null

  start: ->
    this.getFeatures()
    features = @features
    that = this

    if @isRecording == true
      console.log("You are presently recording a scenario")
      # load the current scenario
      scenarioId = @sessionStorage.getItem("autoTestRecorder.currentScenario")
      featureId = @sessionStorage.getItem("autoTestRecorder.currentFeature")
      options = new Array
      if featureId != null
        @currentFeature = AutoTestFeature.find(@projectId, featureId)
        $("select#features").val(featureId)
        #$("select#features").attr("disabled", "disabled")
      if scenarioId != null
        @currentScenario = AutoTestScenario.find(@projectId, @currentFeature.id, scenarioId)
      # Record step of redirected to -> current window location href
      step = @currentScenario.addStep("redirect", {}, window.location.href)
      # This isn't actually starting recording
      console.log("Restarting Recording")
      this.record()
    else
      $("button#stop-recording").hide()
      $("button#record-text-highlight").hide()

  record: ->
    console.log("We are currently recording")
    # Collect actions to a JSON structure
    @isRecording = true
    @sessionStorage.setItem("autoTestRecorder.isRecording", @isRecording)
    # Disable feature selection

    # Disable features button, hide record button, show stop button
    $("select#features").attr("disabled", "disabled")
    $("select#features").hide()
    $("#current-scenario").html("<strong>Currently recording: #{@currentFeature.name} - #{@currentScenario.name}</strong>")
    $("button#record").hide()
    $("button#stop-recording").show()
    $(".recording-bar").addClass("recording")
    $("button#start-text-highlight").show()
    # This is going to have to be moved out at some point is my guess.  It's probably going to get
    # very large
    console.log("Binding DOM events")
    that = this
    stepLocator = {}
    console.log("Binding all links")
    $("a").bind("click", {autoTestRecorder: this}, (event) ->
      event.preventDefault()
      console.log("href is #{$(this).attr('href')}")
      console.log("id is #{$(this).attr('id')}")
      recorder = that
      scenario = that.currentScenario
      # Create a step and save it.
      scenario.addStep("clickEvent", {"type": "id", "value": $(this).attr("id")}, $(this).attr("href"))
      window.location.href = $(this).attr("href")
    )
    # Start recording an input as soon as it's focused.
    console.log("Binding all focus events for text and text areas")
    $("input[type=text], textarea").bind("focus", {autoTestRecorder: this}, (event) ->
      console.log("entered text element")
      console.log($(this).attr("id"))
      stepLocator = {type: "id", value: $(this).attr("id")}
      console.log(stepLocator)
    )
    console.log("Binding all blur events for text elements and text areas")
    $("input[type=text], textarea").bind("blur", (event) ->
      # console.log($(this).attr("id"))
      # console.log("left text element")
      value = $(this).val()
      if value.length > 0
        scenario = that.currentScenario
        scenario.addStep("setElementText", stepLocator, value)
    )
    console.log("Binding all select dropdown changes")

    $("select").bind("change", (event) ->
      value = $(this).val()
      scenario = that.currentScenario
      stepLocator = {type: "id", value: $(this).attr("id")}
      scenario.addStep("selectValue", stepLocator, value)
    )
    console.log("Binding all click events for radio buttons and checkboxes")
    $("input[type=radio], input[type=checkbox]").bind("click", (event) ->
      value = $(this).val()
      scenario = that.currentScenario
      stepLocator = {type: "name", value: $(this).attr("id") }
      scenario.addStep("selectRadio", stepLocator, value)
    )
    console.log("Binding all submit click events")
    $("input[type=submit]").bind("click", (event) ->
      scenario = that.currentScenario
      stepLocator = {type: "id", value: $(this).attr("id")}
      scenario.addStep("submitForm", stepLocator, "")
    )
    return

  stop: ->
    console.log("Stopping Recording")
    @isRecording = false
    @sessionStorage.setItem("autoTestRecorder.isRecording", false)
    @sessionStorage.removeItem("autoTestRecorder.currentFeature")
    @sessionStorage.removeItem("autoTestRecorder.currentScenario")
    $("select#features").removeAttr("disabled").show()
    $("#current-scenario").hide().html('')
    $("button#record").removeAttr("disabled")

  getFeatures: ->
    @features = AutoTestFeature.findAll(@projectId)
    return @features

  setCurrentFeature: (featureId) ->
    @currentFeature = AutoTestFeature.find(@projectId, featureId)
    @sessionStorage.setItem("autoTestRecorder.currentFeature", featureId)

  addScenario: (name) ->
    @currentScenario = AutoTestScenario.create(@projectId, @currentFeature.id, name, window.location.href)
    @sessionStorage.setItem("autoTestRecorder.currentScenario", @currentScenario.id)
    $("button#record").hide()
    $("button#stop-recording").show()

  recordHighlight: (text)->
    scenario = this.currentScenario
    stepLocator = {type: "text highlight on page", value: window.location.pathname}
    scenario.addStep("Highlight Text", stepLocator, text)
