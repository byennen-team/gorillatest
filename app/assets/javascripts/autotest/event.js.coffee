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
    $("a").on("click", AutoTestEvent.bindEvent)
    # Start recording an input as soon as it's focused.
    console.log("Binding all focus events for text and text areas")
    fieldTypes = ["text", "password", "email", "color", "tel", "date", "datetime", "month", "number",
    "range", "search", "tel", "time", "url", "week"]
    console.log("Binding all blur events for text elements and text areas")
    for fieldType in fieldTypes
      AutoTestEvent.bindInput("input", fieldType)
    AutoTestEvent.bindInput("textarea", "")
    console.log("Binding all select dropdown changes")
    $("select").bind("change", (event) ->
      stepLocator = AutoTestEvent.buildLocator(event.currentTarget)
      # {type: "id", value: $(this).attr("id")}
      scenario.addStep("setElementSelected", stepLocator, $(this).val())
    )
    console.log("Binding all click events for radio buttons and checkboxes")
    $("input[type=radio], input[type=checkbox]").bind("click", (event) ->
      stepLocator = AutoTestEvent.buildLocator(event.currentTarget)
      # {type: "name", value: $(this).attr("id") }
      scenario.addStep("clickElement", stepLocator, $(this).val())
    )
    console.log("Binding all submit click events")
    $("input[type=submit]").bind("click", (event) ->
      stepLocator = AutoTestEvent.buildLocator(event.currentTarget)
      # {type: "id", value: $(this).attr("id")}
      scenario.addStep("submitElement", stepLocator, "")
    )
    return

  @bindInput: (elementName, elementType) ->
    recorder = window.autoTestRecorder
    scenario = recorder.currentScenario
    stepLocator = {}
    if elementType == ""
      element = $("#{elementName}")
    else
      element = $("#{elementName}[type=#{elementType}")

    element.bind("focus", (event) ->
      stepLocator = AutoTestEvent.buildLocator(event.currentTarget)
    )
    element.on("blur", (event) ->
      console.log($(this))
      if $(this).val().length > 0
        scenario.addStep("setElementText", stepLocator, $(this).val())
    )

  @bindEvent: (event) ->
    recorder = window.autoTestRecorder
    scenario = recorder.currentScenario
    event.preventDefault()
    console.log($(event.currentTarget).attr("href"))
    stepLocator = AutoTestEvent.buildLocator(event.currentTarget)
    # {type: "id", value: $(this).attr("id")}
    scenario.addStep("clickElement", stepLocator, $(this).attr("href"))
    scenario.addStep("waitForCurrentUrl", {type: "", value: ""}, $(this).attr("href"))
    if $(event.currentTarget).attr("href").substring(0,1) != "#"
      window.location.href = event.currentTarget.href

  @unbind: () ->

  @buildLocator: (element) ->
    if $(element).attr("id")
      return {type: "id", value: $(element).attr("id")}
    else if $(element).attr("name")
      return {type: "name", value: $(element).attr("name")}
    else if $(element).prop("tagName") == "A"
      console.log("link is")
      return {type: "link", value: $(element).text()}



