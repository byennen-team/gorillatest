//= require jquery
//= require underscore
//= require bootstrap
//= require autotest/recorder
//= require autotest/feature
//= require autotest/scenario
//= require autotest/step
//= require autotest/event
//= require autotest/locator_builder
//= require autotest/locator
//= require gui_controller

scripts = document.getElementsByTagName("script")
i = 0
l = scripts.length

while i < l
  if (/iframe/).test(scripts[i].src)
    window.projectId = scripts[i].getAttribute("data-project-id")
    window.authToken =  scripts[i].getAttribute("data-auth")
    if scripts[i].getAttribute("data-api-url")
      window.apiUrl = scripts[i].getAttribute("data-api-url")
    else
      window.apiUrl = "http://autotest.io"
    break
  i++

addEventListener "message", (e)->
  data = e.data
  switch data.messageType
    when "recording"
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
    when "startRecording"
      autoTestGuiController.recording(data.message)
    when "stepAdded"
      $("#step-count").text("#{data.message.stepCount} steps")
    when "featureAdded"
      autoTestGuiController.disableTooltip()
      feature = data.message
      $("select#features").append "<option value=#{feature.featureId}>#{feature.featureName}</option>"
      $("select#features").val(feature.featureId)
      $("button#record").removeAttr("disabled")

$(document).ready ($)->
  window.postParentMessage = (message)->
    parent.postMessage(message, document.referrer)

  window.autoTestRecorder = new AutoTestRecorder window.projectId
  window.autoTestApiUrl = window.apiUrl
  window.autoTestAuthToken = window.authToken

  autoTestGuiController.enableTooltip()

  autoTestFeatures = AutoTestFeature.findAll(window.projectId)
  options = new Array
  $.each autoTestFeatures, (k, v) ->
    options.push "<option value='#{v.id}'>#{v.name}</option>"
  $("select#features").html("<option value=''>Select a Feature...</option>" + options.join(''))
  # $("select#features").bind "change", ->
  #   window.autoTestRecorder.setCurrentFeature($(this).val()) if $(this).val().length > 0

  $("select#features").on "change", ->
    console.log("Sending Message")
    featureId = $(this).val()
    parent.postMessage({messageType: "setFeature", featureId: featureId}, document.referrer)
    autoTestGuiController.enableRecordButton()

  $("#add-feature").click ->
    postParentMessage({messageType: "addFeature"})

  $("#record").click ->
    postParentMessage({messageType: "recordClick"})

    # console.log(window.autoTestGuiController);
    # autoTestGuiController.loadFeatures()
    # $("#add-feature").click(function(e){})
    # autoTestGuiController.enableTooltip()

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



    # if(autoTestRecorder.isRecording === true){
    #   autoTestGuiController.recording(autoTestRecorder);
    #   $("#step-count").text(autoTestRecorder.currentScenario.autoTestSteps.length + " steps")
    # }
    # $("#stop-recording").click(function(){autoTestGuiController.stopRecording()})
    # $("#start-text-highlight").click(function(e){autoTestGuiController.startElementHighlight(e)})
    # $("#stop-record-text-highlight").click(function(e){autoTestGuiController.stopElementHighlight(e)})
