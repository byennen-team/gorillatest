class @IframeController

    @loadFeatures: ->
      autoTestFeatures = AutoTestFeature.findAll(window.projectId)
      options = new Array
      $.each autoTestFeatures, (k, v) ->
        options.push "<option value='#{v.id}'>#{v.name}</option>"
      $("select#features").html("<option value=''>Select a Feature...</option>" + options.join(''))

      $("select#features").on "change", ->
        console.log("Sending Message")
        featureId = $(this).val()
        parent.postMessage({messageType: "setFeature", featureId: featureId}, document.referrer)
        autoTestGuiController.enableRecordButton()

$(document).ready ($)->
  window.postParentMessage = (message)->
    parent.postMessage(message, document.referrer)

  window.autoTestRecorder = new AutoTestRecorder window.projectId
  window.autoTestApiUrl = window.apiUrl
  window.autoTestAuthToken = window.authToken

  autoTestGuiController.enableTooltip()
  IframeController.loadFeatures()

  $("#add-feature").click ->
    postParentMessage({messageType: "addFeature"})

  $("#record").click ->
    postParentMessage({messageType: "recordClick"})

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