class @AutoTestPostMessageHandler

  @handlerMap = {}
  @add: (event, f) ->
    @handlerMap[event] = f
    return

  @perform: (event, featureId) ->
    console.log("Calling Event Handler -> #{event}")
    @handlerMap[event].call(null, featureId)


AutoTestPostMessageHandler.add("setFeature", (featureId) ->
  Autotest.features.fetch()
  Autotest.currentFeature = Autotest.features.findWhere({id: featureId})
)

AutoTestPostMessageHandler.add("recordClick", (featureId) ->
  options = {width: "400px", height: "400px", margin: "0 auto", "overflow-y": "auto", wrapperId: 'scenario-modal'}
  autoTestGuiController.renderModal("scenario_modal", options, ->
    $("input#scenario_name").bind "blur", ->
      if $(this).val().length > 0
        $("button#start-recording").removeAttr("disabled")
      else
        $("button#start-recording").attr("disabled", "disabled")
      return
    )
  return
)

AutoTestPostMessageHandler.add("addFeature", (featureId) ->
  Autotest.featureIndex.showCreateModal()
  new Autotest.Views.FeaturesModal({el: $(".autotest-modal-content")})
)

AutoTestPostMessageHandler.add("viewSteps", ->
  autoTestGuiController.viewSteps()
)

AutoTestPostMessageHandler.add("stopRecording", (featureId) ->
  autoTestRecorder.stop()
)

AutoTestPostMessageHandler.add("selectElement", (featureId) ->
 autoTestGuiController.startElementHighlight()
)

AutoTestPostMessageHandler.add("stopSelectElement", (featureId) ->
  autoTestGuiController.stopElementHighlight()
)