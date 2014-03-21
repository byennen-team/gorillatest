class @IframeMessageHandler

  @handlerMap = {}
  @add: (event, f) ->
    @handlerMap[event] = f
    return

  @perform: (event, data) ->
    console.log("Calling Event Handler -> #{event}")
    console.log(data)
    @handlerMap[event].call(null, data)

IframeMessageHandler.add("recording", (data) ->
  if data.recording == true
    autoTestGuiController.recording(data.message)
    $("#step-count").hover ->
      $(this).css("cursor", "auto")
    $("#step-count").click ->
      postParentMessage({messageType: "viewSteps"})

    $("#stop-recording").click ->
      autoTestGuiController.stopRecording()
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
      autoTestGuiController.recording(data.message)
)

IframeMessageHandler.add("stepAdded", (data) ->
      $("#step-count").text("#{data.message.stepCount} steps")
)

IframeMessageHandler.add("featureAdded", (data) ->
      autoTestGuiController.disableTooltip()
      feature = data.message
      $("select#features").append "<option value=#{feature.featureId}>#{feature.featureName}</option>"
      $("select#features").val(feature.featureId)
      $("button#record").removeAttr("disabled")
)