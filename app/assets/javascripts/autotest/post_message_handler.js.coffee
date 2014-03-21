class @AutoTestPostMessageHandler

  @handlerMap = {}
  @add: (event, f) ->
    @handlerMap[event] = f
    return

  @perform: (event, featureId) ->
    console.log("Calling Event Handler -> #{event}")
    @handlerMap[event].call(null, featureId)


AutoTestPostMessageHandler.add("setFeature", (featureId) ->
  autoTestRecorder.setCurrentFeature(featureId)
)

AutoTestPostMessageHandler.add("recordClick", (featureId) ->
  options = {width: "400px", height: "400px", margin: "0 auto", "overflow-y": "auto", wrapperId: 'scenario-modal'}
  window.parent.renderModal("scenarioModalTemplate", '', options, ->
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
  options = {width: "400px", height: "400px", margin: "0 auto", "overflow-y": "auto", wrapperId: 'feature-modal'}
  window.renderModal("addFeatureModalTemplate", '', options)
  autoTestGuiController.createFeature()
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