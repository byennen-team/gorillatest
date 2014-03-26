class Autotest.Messages.Parent

  @handlerMap = {}

  @add: (event, f) ->
    @handlerMap[event] = f
    return

  @perform: (event, featureId) ->
    if event != undefined
      @handlerMap[event].call(null, featureId)

  @post: (message) ->
    iframe = document.getElementById("autotest-iframe").contentWindow
    iframe.postMessage(message, Autotest.apiUrl)

Autotest.Messages.Parent.add("setFeature", (featureId) ->
  Autotest.features.fetch()
  feature = Autotest.features.findWhere({id: featureId})
  feature.setCurrentFeature()
  Autotest.currentFeature = feature
)

Autotest.Messages.Parent.add("recordClick", (featureId) ->
  scenarioIndex = new Autotest.Views.ScenariosIndex
  scenarioIndex.showCreateModal()
  new Autotest.Views.ScenariosModal({el: $(".autotest-modal-content")})
)

Autotest.Messages.Parent.add("addFeature", (featureId) ->
  Autotest.featureIndex.showCreateModal()
  new Autotest.Views.FeaturesModal({el: $(".autotest-modal-content")})
)

Autotest.Messages.Parent.add("viewSteps", ->
  console.log("Showing step list")
  stepIndex = new Autotest.Views.StepIndex
  stepIndex.view()
)

Autotest.Messages.Parent.add("stopRecording", (featureId) ->
  autoTestRecorder.stop()
)

Autotest.Messages.Parent.add("selectElement", (featureId) ->
 autoTestGuiController.startElementHighlight()
)

Autotest.Messages.Parent.add("stopSelectElement", (featureId) ->
  autoTestGuiController.stopElementHighlight()
)
