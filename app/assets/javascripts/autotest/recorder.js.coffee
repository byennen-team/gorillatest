class @AutoTestRecorder
  constructor: (@projectId) ->
    @authToken = window.autoTestAuthToken
    @baseUrl = "http://autotest.dev/scenarios"
    if window.sessionStorage
      @sessionStorage = window.sessionStorage
    else
      alert("You can't record on this browser")
    @isRecording = @sessionStorage.getItem("autoTestRecorder.isRecording") == "true" ? true : false
    @currentScenario = null

  start: ->
    if @isRecording == true
      console.log("You are presently recording a scenario")
      # load the current scenario
      scenarioId = @sessionStorage.getItem("currentScenario")
      if scenarioId != null
        @currentScenario = AutoTestScenario.find(@projectId, scenarioId)
      # Record step of redirected to -> current window location href
      step = @currentScenario.addStep("redirect", {}, window.location.href)
      # This isn't actually starting recording
      console.log("restarting recording")
      this.record()

  record: ->
    console.log("We are recording")
    # Collect actions to a JSON structure
    @isRecording = true
    @sessionStorage.setItem("autoTestRecorder.isRecording", @isRecording)
    # This is going to have to be moved out at some point is my guess.  It's probably going to get
    # very large
    console.log("binding events")
    that = this
    $(document).ready () ->
      stepLocator = {}
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
      $("input[type=text], textarea").bind("focus", {autoTestRecorder: this}, (event) ->
        console.log("entered text element")
        console.log($(this).attr("id"))
        stepLocator = {type: "id", value: $(this).attr("id")}
        console.log(stepLocator)
      )
      $("input[type=text], textarea").bind("blur", (event) ->
        # console.log($(this).attr("id"))
        # console.log("left text element")
        value = $(this).val()
        scenario = that.currentScenario
        console.log("ADDING STEP")
        scenario.addStep("setElementText", stepLocator, value)
      )
      $("select").bind("change", (event) ->
        value = $(this).val()
        scenario = that.currentScenario
        stepLocator = {type: "id", value: $(this).attr("id")}
        console.log("saving select")
        scenario.addStep("selectValue", stepLocator, value)
      )
      $("input[type=radio], input[type=checkbox]").bind("click", (event) ->
        value = $(this).val()
        scenario = that.currentScenario
        stepLocator = {type: "name", value: $(this).attr("id") }
        console.log("saving radio or checkbox value")
        scenario.addStep("selectRadio", stepLocator, value)
      )
      $("input[type=submit]").bind("click", (event) ->
        #event.preventDefault()
        scenario = that.currentScenario
        stepLocator = {type: "id", value: $(this).attr("id")}
        console.log("recording button")
        scenario.addStep("submitForm", stepLocator, "")
      )
    return

  stop: ->
    @isRecording = false
    @sessionStorage.setItem("isRecording", false)

  addScenario: (name) ->
    @currentScenario = AutoTestScenario.create(@projectId, name, window.location.href)
    @sessionStorage.setItem("currentScenario", @currentScenario.id)
