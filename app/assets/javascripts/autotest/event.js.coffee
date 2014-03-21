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
        AutoTestEvent.unbindScenarioModal()
      ), true)

  @bind: () ->
    stepLocator = {}
    $("a").bind("click", AutoTestEvent.bindClick)
    $("button").bind("click", AutoTestEvent.bindClick)
    # Start recording an input as soon as it's focused.
    fieldTypes = ["text", "password", "email", "color", "tel", "date", "datetime", "month", "number",
    "range", "search", "tel", "time", "url", "week"]
    for fieldType in fieldTypes
      elementType = AutoTestEvent.createInputBinding("input", fieldType)
      elementType.bind("focus", AutoTestEvent.bindFocus)
      elementType.bind("blur", AutoTestEvent.bindBlur)
    textArea = AutoTestEvent.createInputBinding("textarea", "")
    textArea.bind("focus", AutoTestEvent.bindFocus)
    textArea.bind("blur", AutoTestEvent.bindBlur)
    $("select").bind("change", AutoTestEvent.bindSelect)
    $("input[type=radio], input[type=checkbox]").bind("click", AutoTestEvent.bindClick)
    $("input[type=submit]").bind("click", AutoTestEvent.bindSubmit)
    AutoTestEvent.bindConfirmation()
    AutoTestEvent.bindAlert()
    return

  @createInputBinding: (elementName, elementType) ->
    stepLocator = {}
    if elementType == ""
      element = $("#{elementName}")
    else
      element = $("#{elementName}[type=#{elementType}]")
    return element

  @bindClick: (event) ->
    AutoTestEvent.addStep(event, "clickElement", $(this).attr("href"))

  @bindFocus: (event) ->
    stepLocator = new AutoTestLocatorBuilder(event.currentTarget).build()

  @bindBlur: (event) ->
    if $(this).val().length > 0
      AutoTestEvent.addStep(event, "setElementText", $(this).val())

  @bindSelect: (event) ->
    AutoTestEvent.addStep(event, "setElementSelected", $(this).val())

  @bindClick: (event) ->
    AutoTestEvent.addStep(event, "clickElement", $(this).val())

  @bindSubmit: (event) ->
    AutoTestEvent.addStep(event, "submitElement", null)

  @bindConfirmation: ->
    window.originalConfirm = window.confirm
    window.confirm = (message) ->
      result = window.originalConfirm(message)
      AutoTestEvent.addStep(null, "assertConfirmation", message)
      if (!result)
        AutoTestEvent.addStep(null, "chooseCancelOnNextConfirmation", "Cancel")
      else
        AutoTestEvent.addStep(null, "chooseAcceptOnNextConfirmation", "OK")
      return result
    return

  @bindAlert: () ->
    window.originalAlert = window.alert
    window.alert = (alert) ->
      window.originalAlert(alert)
      # Add step here:
      @scenario.addStep("assertAlert", {}, alert)
      return
    return

  @unbind: () ->
    console.log("UNbinding all elements")
    $("a").unbind("click", AutoTestEvent.bindClick)
    $("button").unbind("click", AutoTestEvent.bindClick)
    fieldTypes = ["text", "password", "email", "color", "tel", "date", "datetime", "month", "number",
    "range", "search", "tel", "time", "url", "week"]
    for fieldType in fieldTypes
      elementType = AutoTestEvent.createInputBinding("input", fieldType)
      elementType.unbind("focus", AutoTestEvent.bindBlur)
      elementType.unbind("blur", AutoTestEvent.bindInput)

    textArea = AutoTestEvent.createInputBinding("textarea", "")
    textArea.unbind("focus", AutoTestEvent.bindFocus)
    textArea.unbind("blur", AutoTestEvent.bindBlur)
    $("select").unbind("change", AutoTestEvent.bindSelect)
    $("input[type=radio], input[type=checkbox]").unbind("click", AutoTestEvent.bindClick)
    $("input[type=submit]").unbind("click", AutoTestEvent.bindSubmit)
    window.confirm = window.originalConfirm
    window.alert = window.originalAlert
    return

  @unbindIframe: ->
    $("#step-count").unbind("click", AutoTestEvent.bindClick)

  @unbindElementModal: ->
    $("#select-element-modal").unbind("mouseenter")
    $("#select-element-modal").unbind("mouseleave")
    $("#select-element-modal a").unbind("click", AutoTestEvent.bindClick)
    $("#select-element-modal button").unbind("click", AutoTestEvent.bindClick)
    $("#select-element-modal input[type=radio]").unbind("click", AutoTestEvent.bindClick)
    $("button#start-text-highlight").unbind("click", AutoTestEvent.bindClick)
    $("button#stop-record-text-highlight").unbind("click", AutoTestEvent.bindClick)
    return

  @unbindScenarioModal: ->
    $("#autotest-modal button").unbind("click", AutoTestEvent.bindClick)

  @addStep: (event, type, value) ->
    scenario = window.autoTestRecorder.currentScenario
    confirmationTypes = ["assertConfirmation", "chooseCancelOnNextConfirmation", "chooseAcceptOnNextConfirmation"]
    if $.inArray(type, confirmationTypes) == -1
      stepLocator = new AutoTestLocatorBuilder(event.currentTarget).build()
    else
      stepLocator = {}
    scenario.addStep(type, stepLocator, value)



