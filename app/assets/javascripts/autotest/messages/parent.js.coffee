class Autotest.Messages.Parent

  @handlerMap = {}

  @add: (event, f) ->
    @handlerMap[event] = f
    return

  @perform: (event, featureId) ->
    if event != undefined
      @handlerMap[event].call(null, featureId)

  @post: (message) ->
    if Autotest.developerMode == true
      iframe = document.getElementById("autotest-dev-iframe").contentWindow
    else
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
  # featureIndex = new Autotest.Views.FeatureIndex
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

Autotest.Messages.Parent.add("stopPlayback", (featureId) ->
  Autotest.currentSteps.stop()
  # developerIndex = new Autotest.Views.DeveloperIndex
  # developerIndex.showHidePlayButtons()
)

Autotest.Messages.Parent.add("startPlayback", (featureId) ->
  Autotest.currentSteps = null
  steps = Autotest.currentScenario.steps()
  steps.play()
)

Autotest.Messages.Parent.add("pausePlayback", (featureId) ->
  Autotest.currentSteps.pause()
)

Autotest.Messages.Parent.add("forwardPlayback", (featureId) ->
  Autotest.currentSteps.next()
)

Autotest.Messages.Parent.add("backwardPlayback", (featureId) ->
  Autoest.currentSteps.previous()
)

Autotest.Messages.Parent.add("resumePlayback", (data) ->
  steps = Autotest.currentScenario.steps()
  steps.play()
)

Autotest.Messages.Parent.add("iframeLoadComplete", (data) ->
  if $("iframe#autotest-dev-iframe").length > 0
    $("iframe#autotest-dev-iframe").trigger("loadComplete")
  else
    $("iframe#autotest-iframe").trigger("loadComplete")
)

