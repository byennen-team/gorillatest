class @AutoTestEvent 

  constructor: () ->
    @scenario = window.autoTestRecorder
    @elementType = ""
    @scenario = ""

  @bind: () ->
    recorder = window.autoTestRecorder
    scenario = recorder.currentScenario
    stepLocator = {}
    console.log("Binding all links")    
    $("a").bind("click", AutoTestEvent.bindEvent)
    #   event.preventDefault()
    #   # Create a step and save it.
    #   scenario.addStep("clickEvent", {"type": "id", "value": $(this).attr("id")}, $(this).attr("href"))
    #   window.location.href = $(this).attr("href")
    # )
    # Start recording an input as soon as it's focused.
    console.log("Binding all focus events for text and text areas")
    $("input[type=text], textarea").bind("focus", (event) ->
      stepLocator = {type: "id", value: $(this).attr("id")}
    )
    console.log("Binding all blur events for text elements and text areas")
    $("input[type=text], textarea").bind("blur", (event) ->
      if $(this).val().length > 0
        scenario.addStep("setElementText", stepLocator, $(this).val())
    )
    console.log("Binding all select dropdown changes")
    $("select").bind("change", (event) ->
      stepLocator = {type: "id", value: $(this).attr("id")}
      scenario.addStep("setElementSelected", stepLocator, $(this).val())
    )
    console.log("Binding all click events for radio buttons and checkboxes")
    $("input[type=radio], input[type=checkbox]").bind("click", (event) ->
      stepLocator = {type: "name", value: $(this).attr("id") }
      scenario.addStep("clickElement", stepLocator, $(this).val())
    )
    console.log("Binding all submit click events")
    $("input[type=submit]").bind("click", (event) ->
      stepLocator = {type: "id", value: $(this).attr("id")}
      scenario.addStep("submitElement", stepLocator, "")
    )
    return

  @bindEvent: (event) ->
    recorder = window.autoTestRecorder
    scenario = recorder.currentScenario    
    event.preventDefault()
    #stepLocator = {type: "id", value: $(this).attr("id")}
    scenario.addStep("clickElement", {"type": "id", "value": $(this).attr("id")}, $(this).attr("href"))
    scenario.addStep("waitForCurrentUrl", {type: "", value: ""}, $(this).attr("href"))
    window.location.href = event.currentTarget.href

  @unbind: () ->
