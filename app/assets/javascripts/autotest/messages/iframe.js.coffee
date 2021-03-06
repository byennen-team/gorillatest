class Autotest.Messages.Iframe

  @handlerMap = {}

  @add: (event, f) ->
    @handlerMap[event] = f
    return

  @perform: (event, data) ->
    if event != undefined
      @handlerMap[event].call(null, data)

  @post: (message) ->
    parent.postMessage(message, document.referrer)

Autotest.Messages.Iframe.add("recording", (data) ->
  iframeIndex = new Autotest.Views.IframeIndex
  iframeIndex.recording(data)
)

Autotest.Messages.Iframe.add("startRecording", (data) ->
  iframeIndex = new Autotest.Views.IframeIndex
  iframeIndex.startRecording(data.message)
)

Autotest.Messages.Iframe.add("stepAdded", (data) ->
  iframeIndex = new Autotest.Views.IframeIndex
  iframeIndex.updateSteps(data)
)

Autotest.Messages.Iframe.add("featureAdded", (data) ->
  Autotest.features.selected = data.message.featureId
  Autotest.features.fetch()
)

Autotest.Messages.Iframe.add("showScenario", (data) ->
  developerIndex = new Autotest.Views.DeveloperIndex
  developerIndex.showCurrentScenario(data.projectName, data.scenarioName)
)

Autotest.Messages.Iframe.add("playStep", (data) ->
  developerIndex = new Autotest.Views.DeveloperIndex
  developerIndex.showPlayStep(data.message)
)

Autotest.Messages.Iframe.add("stopPlayback", (data) ->
  developerIndex = new Autotest.Views.DeveloperIndex
  developerIndex.showHidePlayButtons()
)

Autotest.Messages.Iframe.add("resumePlayback", (data) ->
  developerIndex = new Autotest.Views.DeveloperIndex
  $("#play").trigger("click")
)

Autotest.Messages.Iframe.add("stopSelectElement", (data) ->
  $("#stop-record-text-highlight").trigger("click")
)
