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
    options = new Array
    features = @features
    that = this
    $.each(features, (k, v) ->
      options.push "<option value='#{v.id}'>#{v.name}</option>"
    )
    $("select#features").html("<option value=''>Select a Feature...</option>" + options.join(''))
    $("select#features").bind("change", ->
      that.setCurrentFeature($(this).val()) if $(this).val().length > 0
    )
    if @isRecording == true
      console.log("You are presently recording a scenario")
      # load the current scenario
      scenarioId = @sessionStorage.getItem("autoTestRecorder.currentScenario")
      featureId = @sessionStorage.getItem("autoTestRecorder.currentFeature")
      options = new Array
      if featureId != null
        @currentFeature = AutoTestFeature.find(@projectId, featureId)
        $("select#features").val(featureId)
        $("select#features").attr("disabled", "disabled")
      if scenarioId != null
        @currentScenario = AutoTestScenario.find(@projectId, @currentFeature.id, scenarioId)
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
        scenario = that.currentScenario
        stepLocator = {type: "id", value: $(this).attr("id")}
        console.log("recording button")
        scenario.addStep("submitForm", stepLocator, "")
      )
    return

  stop: ->
    @isRecording = false
    @sessionStorage.setItem("autoTestRecorder.isRecording", false)
    @sessionStorage.removeItem("autoTestRecorder.currentFeature")
    @sessionStorage.removeItem("autoTestRecorder.currentScenario")
    $("select#features").removeAttr("disabled")

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
    $("button#stop").show()
    $("button#stop").bind("click", ->
      this.stop()
    )
