class Autotest.Messages.Parent

  @handlerMap = {}
  @add: (event, f) ->
    @handlerMap[event] = f
    return

  @perform: (event, featureId) ->
    console.log("event is #{event}")
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
  stepIndex = new Autotest.Views.Steps
  stepIndex.view()
)

Autotest.Messages.Parent.add("stopRecording", (featureId) ->
  autoTestRecorder.stop()
)

Autotest.Messages.Parent.add("selectElement", (featureId) ->
 AutotestGuiController.startElementHighlight()
)

Autotest.Messages.Parent.add("stopSelectElement", (featureId) ->
  AutotestGuiController.stopElementHighlight()
)
