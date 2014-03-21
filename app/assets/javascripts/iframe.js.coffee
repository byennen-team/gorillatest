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
//= require autotest/gui_controller
//= require autotest/iframe_message_handler

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
  IframeMessageHandler.perform(data.messageType, data)

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

  $("select#features").on "change", ->
    console.log("Sending Message")
    featureId = $(this).val()
    parent.postMessage({messageType: "setFeature", featureId: featureId}, document.referrer)
    autoTestGuiController.enableRecordButton()

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
