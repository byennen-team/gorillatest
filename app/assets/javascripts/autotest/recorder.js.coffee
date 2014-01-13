class @AutoTestRecorder
  constructor: (@authToken, @projectId) ->
    @baseUrl = "http://autotest.dev/scenarios"
    if window.sessionStorage
      @sessionStorage = window.sessionStorage
    else
      alert("You can't record on this browser")
    @isRecording = @sessionStorage.getItem("isRecording") == "true" ? true : false
    @currentScenario = null

  start: ->
    if @isRecording == true
      console.log("You are presently recording a scenario")
      # load the current scenario
      scenarioId = @sessionStorage.getItem("currentScenario")
      if scenarioId != null
        @currentScenario = AutoTestScenario.find(@projectId, scenarioId)
      # Record step of redirected to -> current window location href
      step = @currentScenario.addStep(this, "redirect", {}, window.location.href)
      # This isn't actually starting recording
      this.record()

  record: ->
    # Collect actions to a JSON structure
    @isRecording = true
    @sessionStorage.setItem("autoTestRecorder.isRecording", @isRecording)
    # This is going to have to be moved out at some point is my guess.  It's probably going to get
    # very large
    $("a").bind("click", {autoTestRecorder: this}, (event) ->
      event.preventDefault()
      console.log("href is #{$(this).attr('href')}")
      console.log("id is #{$(this).attr('id')}")
      recorder = event.data.autoTestRecorder
      scenario = recorder.currentScenario
      # Create a step and save it.
      scenario.addStep("clickEvent", {"type": "id", "value": $(this).attr("id")}, $(this).attr("href"))
    )
    # Start recording an input as soon as it's focused.
    $("input[type=text]").bind("focus", {autoTestRecorder: this}, (event) ->
      stepLocator = {type: "id", value: $(this).attr("id")}
      $("input[type=text]").bind("blur", (event) ->
        value = $(this).val()
        AutoTestRecorder.addStep(event.data.autoTestRecorder, "setElementText", stepLocator, value)
        @steps.push(step)
      )
    )
    return

  stop: ->
    @isRecording = false
    @sessionStorage.setItem("isRecording", false)

  addScenario: (name) ->
    @currentScenario = AutoTestScenario.create(@authToken, @projectId, name, window.location.href)
    @sessionStorage.setItem("currentScenario", @currentScenario.id)
