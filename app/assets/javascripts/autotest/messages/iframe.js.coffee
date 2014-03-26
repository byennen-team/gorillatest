class Autotest.Messages.Iframe

  @handlerMap = {}

  @add: (event, f) ->
    @handlerMap[event] = f
    return

  @perform: (event, data) ->
    if event != undefined
     @handlerMap[event].call(null, data)

  @post: (message) ->
    console.log("Posting message to parent")
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