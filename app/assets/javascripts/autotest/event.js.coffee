class Autotest.Event

  constructor: () ->
    @scenario = window.autoTestRecorder
    @elementType = ""
    @scenario = ""

  @bindDomNodeInsert: () ->
    document.addEventListener('DOMNodeInserted', Autotest.Event.eventListner)
    # ( (e)->
    #   if $
    #     Autotest.Event.unbind()
    #     Autotest.Event.bind()
    #     Autotest.Event.unbindElementModal()
    #     Autotest.Event.unbindScenarioModal()
    #   ), true)

  @unbindDomNodeInsert: () ->
    document.removeEventListener('DOMNodeInserted', Autotest.Event.eventListner)

  @eventListner: ->
    Autotest.Event.unbind()
    Autotest.Event.bind()
    Autotest.Event.unbindElementModal()
    Autotest.Event.unbindScenarioModal()

  @bind: () ->
    stepLocator = {}
    $("a").bind("click", Autotest.Event.bindClick)
    $("button").bind("click", Autotest.Event.bindClick)
    # Start recording an input as soon as it's focused.
    fieldTypes = ["text", "password", "email", "color", "tel", "date", "datetime", "month", "number",
    "range", "search", "tel", "time", "url", "week"]
    for fieldType in fieldTypes
      elementType = Autotest.Event.createInputBinding("input", fieldType)
      elementType.bind("focus", Autotest.Event.bindFocus)
      elementType.bind("blur", Autotest.Event.bindBlur)
    textArea = Autotest.Event.createInputBinding("textarea", "")
    textArea.bind("focus", Autotest.Event.bindFocus)
    textArea.bind("blur", Autotest.Event.bindBlur)
    $("select").bind("change", Autotest.Event.bindSelect)
    $("input[type=radio], input[type=checkbox]").bind("click", Autotest.Event.bindClick)
    $("input[type=submit]").bind("click", Autotest.Event.bindSubmit)
    Autotest.Event.bindConfirmation()
    Autotest.Event.bindAlert()
    return

  @createInputBinding: (elementName, elementType) ->
    stepLocator = {}
    if elementType == ""
      element = $("#{elementName}")
    else
      element = $("#{elementName}[type=#{elementType}]")
    return element

  @bindFocus: (event) ->
    stepLocator = new Autotest.LocatorBuilder(event.currentTarget).build()

  @bindBlur: (event) ->
    if $(this).val().length > 0
      Autotest.Event.addStep(event, "setElementText", $(this).val(), "")

  @bindSelect: (event) ->
    console.log($(this).children(":selected").text())
    Autotest.Event.addStep(event, "setElementSelected", $(this).val(), $(this).children(":selected").text())

  @bindClick: (event) ->
    Autotest.Event.addStep(event, "clickElement", $(this).text(), "")

  @bindSubmit: (event) ->
    Autotest.Event.addStep(event, "submitElement", null, "")

  @bindConfirmation: ->
    window.originalConfirm = window.confirm
    window.confirm = (message) ->
      result = window.originalConfirm(message)
      Autotest.Event.addStep(null, "assertConfirmation", message, "")
      if (!result)
        Autotest.Event.addStep(null, "chooseCancelOnNextConfirmation", "Cancel", "")
      else
        Autotest.Event.addStep(null, "chooseAcceptOnNextConfirmation", "OK", "")
      return result
    return

  @bindAlert: () ->
    window.originalAlert = window.alert
    window.alert = (alert) ->
      window.originalAlert(alert)
      # Add step here:
      @scenario.addStep("assertAlert", {}, alert, "")
      return
    return

  @unbind: () ->
    console.log("UNbinding all elements")
    $("a").unbind("click", Autotest.Event.bindClick)
    $("button").unbind("click", Autotest.Event.bindClick)
    fieldTypes = ["text", "password", "email", "color", "tel", "date", "datetime", "month", "number",
    "range", "search", "tel", "time", "url", "week"]
    for fieldType in fieldTypes
      elementType = Autotest.Event.createInputBinding("input", fieldType)
      elementType.unbind("focus", Autotest.Event.bindBlur)
      elementType.unbind("blur", Autotest.Event.bindInput)

    textArea = Autotest.Event.createInputBinding("textarea", "")
    textArea.unbind("focus", Autotest.Event.bindFocus)
    textArea.unbind("blur", Autotest.Event.bindBlur)
    $("select").unbind("change", Autotest.Event.bindSelect)
    $("input[type=radio], input[type=checkbox]").unbind("click", Autotest.Event.bindClick)
    $("input[type=submit]").unbind("click", Autotest.Event.bindSubmit)
    window.confirm = window.originalConfirm
    window.alert = window.originalAlert
    return

  @unbindIframe: ->
    $("#step-count").unbind("click", Autotest.Event.bindClick)

  @unbindElementModal: ->
    $("#select-element-modal").unbind("mouseenter")
    $("#select-element-modal").unbind("mouseleave")
    $("#select-element-modal a").unbind("click", Autotest.Event.bindClick)
    $("#select-element-modal button").unbind("click", Autotest.Event.bindClick)
    $("#select-element-modal input[type=radio]").unbind("click", Autotest.Event.bindClick)
    $("button#start-text-highlight").unbind("click", Autotest.Event.bindClick)
    $("button#stop-record-text-highlight").unbind("click", Autotest.Event.bindClick)
    return

  @unbindScenarioModal: ->
    $("#autotest-modal button").unbind("click", Autotest.Event.bindClick)

  @addStep: (event, type, value, other_text) ->
    scenario = Autotest.currentScenario
    confirmationTypes = ["assertConfirmation", "chooseCancelOnNextConfirmation", "chooseAcceptOnNextConfirmation"]
    console.log(other_text)
    if $.inArray(type, confirmationTypes) == -1
      stepLocator = new Autotest.LocatorBuilder(event.currentTarget).build()
      scenario.addStep({event_type: type, locator_type: stepLocator.type, locator_value: stepLocator.value, text: value, other_text: other_text})
    else
      stepLocator = {}
      scenario.addStep({event_type: type, locator_type: "", locator_value: "", text: value, other_text: other_text})



