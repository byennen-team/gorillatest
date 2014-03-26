class Autotest.Views.IframeIndex extends Backbone.View

  events: {
    "click #add-feature": "addFeature"
    "click #record": "record"
    "click #step-count": "showStepCount"
    "click #stop-recording": "stopRecording"
    "click #start-text-highlight": "startTextHighlight"
    "click #stop-record-text-highlight": "stopTextHighlight"
  }

  addFeature: ->
    Autotest.Messages.Iframe.post({messageType: "addFeature"})

  record: ->
    Autotest.Messages.Iframe.post({messageType: "recordClick"})

  showStepCount: ->
    console.log("posting view step count")
    Autotest.Messages.Iframe.post({messageType: "viewSteps"})

  stopRecording: ->
    Autotest.Messages.Iframe.post({messageType: "stopRecording"})
    $(".recording-bar").removeClass("recording")
    $("select#features").removeAttr("disabled").show()
    # $("button#add-feature").show()
    $("#current-scenario").hide().html('')
    if $("#features").find(":selected").val()
      $("button#record").removeAttr("disabled")
      this.disableToolTip()
    else
      $("button#record").attr("disabled", "disabled")
      this.enableToolTip()

    $("#step-count-text").hide()
    $("#step-count").text('')
    $("#step-count").hide()
    $("#stop-recording").hide()
    $("#start-text-highlight").hide()
    $("#stop-record-text-highlight").hide()
    $("button#add-feature").show()
    $("#record").show()

  startTextHighlight: ->
    $("button#start-text-highlight").hide()
    $("button#stop-record-text-highlight").show()
    Autotest.Messages.Iframe.post({messageType: "selectElement"})

  stopTextHighlight: ->
    $("button#stop-record-text-highlight").hide()
    $("button#start-text-highlight").show()
    Autotest.Messages.Iframe.post({messageType: "stopSelectElement"})

  updateSteps: (data) ->
    $("#step-count").text("#{data.message.stepCount} steps")

  recording: (data) ->
    console.log("Data recording is #{data.recording}")
    if data.recording == true
      console.log("calling start recording")
      this.startRecording(data.message)

  startRecording: (message) ->
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

  enableToolTip: ->
    $("#record-button-wrapper").tooltip("enable")

  disableToolTip: ->
    $("#record-button-wrapper").tooltip("disable")
