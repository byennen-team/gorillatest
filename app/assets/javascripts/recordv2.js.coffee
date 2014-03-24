//= require bPopup.min

//= require underscore
//= require backbone
//= require backbone_rails_sync
//= require autotest/autotest
//= require_tree ./autotest/templates
//= require_tree ./autotest/models
//= require_tree ./autotest/collections
//= require_tree ./autotest/views
//= require_tree ./autotest/routers
//= require autotest/gui_controller
//= require ./autotest/recorder
//= require ./autotest/post_message_handler
//= require_self

# Need to figure out how to namespace these so they don't pollute global windows vars - jkr
$(document).ready () ->

  styleSheetUrl = Autotest.apiUrl + "/assets/application/recorder.css"
  $('head').append("<link rel='stylesheet' type='text/css' href='"+ styleSheetUrl + "'>");

  iframeHtml = JST["autotest/templates/iframe"]()
  stepsHtml = JST["autotest/templates/steps_list"]()
  $("body").prepend(iframeHtml)
  $("body").append(stepsHtml)

  window.autoTestRecorder = new AutoTestRecorder window.projectId

  window.addEventListener "message", (e)->
    data = e.data
    AutoTestPostMessageHandler.perform(data.messageType, data.featureId)

  postMessageToIframe = (message)->
    console.log("posting")
    iframe = document.getElementById("autotest-iframe").contentWindow
    iframe.postMessage(message, Autotest.apiUrl)

  window.postMessageToIframe = postMessageToIframe

  autoTestRecorder.start()
