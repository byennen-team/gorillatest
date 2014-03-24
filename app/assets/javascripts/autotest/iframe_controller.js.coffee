class @IframeController

  # @enableRecordButton: ->
  #   if $("select#features").val().length > 0
  #     $("button#record").removeAttr("disabled")
  #     IframeController.disableTooltip()
  #   else
  #     $("#record").attr("disabled", "disabled")
  #     IframeController.enableTooltip()

  # @enableTooltip: () ->
  #   $("#record-button-wrapper").tooltip("enable")

  # @disableTooltip: () ->
  #   $("#record-button-wrapper").tooltip("disable")

  @recording: (message) ->
    $("#current-scenario").text("Currently recording #{message.featureName} - #{message.scenarioName}")
    $("#current-scenario").show()
    $("button#record").hide()
    $("button#stop-recording").show()
    $("#start-text-highlight").show()
    $("select#features").attr("disabled", "disabled")
    $("select#features").hide()
    $("button#add-feature").hide()
    $("#step-count").show()
    $(".recording-bar").addClass("recording")
    $("#step-count-text").show()

  @stopRecording: ->
    $(".recording-bar").removeClass("recording")
    $("select#features").removeAttr("disabled").show()
    # $("button#add-feature").show()
    $("#current-scenario").hide().html('')
    if $("#features").find(":selected").val()
      $("button#record").removeAttr("disabled")
      AutoTestGuiController.disableTooltip()
    else
      $("button#record").attr("disabled", "disabled")
      IframeController.enableTooltip()

    $("#step-count-text").hide()
    $("#step-count").text('')
    $("#step-count").hide()
    $("#stop-recording").hide()
    $("#start-text-highlight").hide()
    $("#stop-record-text-highlight").hide()
    $("button#add-feature").show()
    $("#record").show()

$(document).ready ($)->
  window.postParentMessage = (message)->
    parent.postMessage(message, document.referrer)

  $("#add-feature").click ->
    postParentMessage({messageType: "addFeature"})

  $("#record").click ->
    postParentMessage({messageType: "recordClick"})

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