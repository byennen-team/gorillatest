class @IframeMessageHandler

  @handlerMap = {}
  @add: (event, f) ->
    @handlerMap[event] = f
    return

  @perform: (event, data) ->
    if event != undefined
     @handlerMap[event].call(null, data)

IframeMessageHandler.add("recording", (data) ->
  console.log("recording called")
  if data.recording == true
    IframeController.recording(data.message)
    $("#step-count").hover ->
      $(this).css("cursor", "auto")
    $("#step-count").click ->
      postParentMessage({messageType: "viewSteps"})

    $("#stop-recording").click ->
      IframeController.stopRecording()
      postParentMessage({messageType: "stopRecording"})

    $("#start-text-highlight").click ->
      $("button#start-text-highlight").hide()
      $("button#stop-record-text-highlight").show()

      postParentMessage({messageType: "selectElement"})

      $("#stop-record-text-highlight").click ->
        $("button#stop-record-text-highlight").hide()
        $("button#start-text-highlight").show()
        postParentMessage({messageType: "stopSelectElement"})
)

IframeMessageHandler.add("startRecording", (data) ->
  scenarioIndex = new Autotest.Views.ScenariosIndex
  scenarioIndex.startRecording(data.message)
)

IframeMessageHandler.add("stepAdded", (data) ->
      $("#step-count").text("#{data.message.stepCount} steps")
)

IframeMessageHandler.add("featureAdded", (data) ->
      Autotest.features.selected = data.message.featureId
      Autotest.features.fetch()
)