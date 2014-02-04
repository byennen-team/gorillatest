class @AutoTestEvent

  constructor: () ->
    @scenario = window.autoTestRecorder
    @elementType = ""
    @scenario = ""

  @bindDomNodeInsert: () ->
    document.addEventListener('DOMNodeInserted', ( (e)->
      if $
        AutoTestEvent.unbind()
        AutoTestEvent.bind()
        AutoTestEvent.unbindElementModal()
      ), true)

  @bind: () ->
    recorder = window.autoTestRecorder
    scenario = recorder.currentScenario
    stepLocator = {}
    console.log("Binding all links")
    $("a").bind("click", AutoTestEvent.bindClick)
    $("button").bind("click", AutoTestEvent.bindClick)
    # Start recording an input as soon as it's focused.
    console.log("Binding all focus events for text and text areas")
    fieldTypes = ["text", "password", "email", "color", "tel", "date", "datetime", "month", "number",
    "range", "search", "tel", "time", "url", "week"]
    console.log("Binding all blur events for text elements and text areas")
    for fieldType in fieldTypes
      elementType = AutoTestEvent.createInputBinding("input", fieldType)
      elementType.bind("focus", AutoTestEvent.bindFocus)
      elementType.bind("blur", AutoTestEvent.bindBlur)
    textArea = AutoTestEvent.createInputBinding("textarea", "")
    textArea.bind("focus", AutoTestEvent.bindFocus)
    textArea.bind("blur", AutoTestEvent.bindBlur)
    console.log("Binding all select dropdown changes")
    $("select").bind("change", AutoTestEvent.bindSelect)
    console.log("Binding all click events for radio buttons and checkboxes")
    $("input[type=radio], input[type=checkbox]").bind("click", AutoTestEvent.bindClick)
    console.log("Binding all submit click events")
    $("input[type=submit]").bind("click", AutoTestEvent.bindSubmit)
    return

  @createInputBinding: (elementName, elementType) ->
    recorder = window.autoTestRecorder
    scenario = recorder.currentScenario
    stepLocator = {}
    if elementType == ""
      element = $("#{elementName}")
    else
      element = $("#{elementName}[type=#{elementType}]")
    return element

    element.bind("focus", AutoTestEvent.bindBlur)
    element.on("blur", AutoTestEvent.bindInput)

  @bindClick: (event) ->
    recorder = window.autoTestRecorder
    scenario = recorder.currentScenario
    console.log($(event.currentTarget).attr("href"))
    stepLocator = new AutoTestLocatorBuilder(event.currentTarget).build()
    # {type: "id", value: $(this).attr("id")}
    scenario.addStep("clickElement", stepLocator, $(this).attr("href"))
    # scenario.addStep("waitForCurrentUrl", {type: "", value: ""}, $(this).attr("href"))
    # if $(event.currentTarget).attr("href").substring(0,1) != "#"
    #   window.location.href = event.currentTarget.href

  @bindFocus: (event) ->
    recorder = window.autoTestRecorder
    scenario = recorder.currentScenario
    stepLocator = new AutoTestLocatorBuilder(event.currentTarget).build()

  @bindBlur: (event) ->
    recorder = window.autoTestRecorder
    scenario = recorder.currentScenario
    stepLocator = new AutoTestLocatorBuilder(event.currentTarget).build()
    if $(this).val().length > 0
      scenario.addStep("setElementText", stepLocator, $(this).val())

  @bindSelect: (event) ->
    recorder = window.autoTestRecorder
    scenario = recorder.currentScenario
    stepLocator = new AutoTestLocatorBuilder(event.currentTarget).build()
    # {type: "id", value: $(this).attr("id")}
    scenario.addStep("setElementSelected", stepLocator, $(this).val())

  @bindClick: (event) ->
    recorder = window.autoTestRecorder
    scenario = recorder.currentScenario
    stepLocator = new AutoTestLocatorBuilder(event.currentTarget).build()
    # {type: "name", value: $(this).attr("id") }
    scenario.addStep("clickElement", stepLocator, $(this).val())

  @bindSubmit: (event) ->
    recorder = window.autoTestRecorder
    scenario = recorder.currentScenario
    stepLocator = new AutoTestLocatorBuilder(event.currentTarget).build()
    # {type: "id", value: $(this).attr("id")}
    scenario.addStep("submitElement", stepLocator, "")

  @unbind: () ->
    console.log("UNbinding all elements")
    $("a").unbind("click", AutoTestEvent.bindClick)
    $("button").unbind("click", AutoTestEvent.bindClick)
    fieldTypes = ["text", "password", "email", "color", "tel", "date", "datetime", "month", "number",
    "range", "search", "tel", "time", "url", "week"]
    console.log("Binding all blur events for text elements and text areas")
    for fieldType in fieldTypes
      elementType = AutoTestEvent.createInputBinding("input", fieldType)
      elementType.unbind("focus", AutoTestEvent.bindBlur)
      elementType.unbind("blur", AutoTestEvent.bindInput)

    textArea = AutoTestEvent.createInputBinding("textarea", "")
    textArea.unbind("focus", AutoTestEvent.bindFocus)
    textArea.unbind("blur", AutoTestEvent.bindBlur)
    console.log("Binding all select dropdown changes")
    $("select").unbind("change", AutoTestEvent.bindSelect)
    console.log("Binding all click events for radio buttons and checkboxes")
    $("input[type=radio], input[type=checkbox]").unbind("click", AutoTestEvent.bindClick)
    console.log("Binding all submit click events")
    $("input[type=submit]").unbind("click", AutoTestEvent.bindSubmit)
    return

  @unbindElementModal: ->
    console.log("Unbinding modal")
    $("#select-element-modal").unbind("mouseenter")
    $("#select-element-modal").unbind("mouseleave")
    $("#select-element-modal a").unbind("click", AutoTestEvent.bindClick)
    $("#select-element-modal button").unbind("click", AutoTestEvent.bindClick)
    $("#select-element-modal input[type=radio]").unbind("click", AutoTestEvent.bindClick)
    $("button#start-text-highlight").unbind("click", AutoTestEvent.bindClick)
    $("button#stop-record-text-highlight").unbind("click", AutoTestEvent.bindClick)
    return


