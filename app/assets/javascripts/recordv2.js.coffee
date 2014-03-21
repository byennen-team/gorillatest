//= require bPopup.min
//= require underscore
//= require autotest/recorder
//= require autotest/feature
//= require autotest/scenario
//= require autotest/step
//= require autotest/event
//= require autotest/locator_builder
//= require autotest/locator
//= require autotest/gui_controller
//= require autotest/post_message_handler
//= require_tree ./autotest/templates/
//= require_self

scripts = document.getElementsByTagName("script")
i = 0
l = scripts.length

while i < l
  if (/recordv2/).test(scripts[i].src)
    window.projectId = scripts[i].getAttribute("data-project-id")
    window.authToken =  scripts[i].getAttribute("data-auth")
    if scripts[i].getAttribute("data-api-url")
    	window.apiUrl = scripts[i].getAttribute("data-api-url")
    else
    	window.apiUrl = "http://autotest.io"
    break
  i++


# Need to figure out how to namespace these so they don't pollute global windows vars - jkr
$(document).ready () ->

  styleSheetUrl = window.apiUrl + "/assets/application/recorder.css"
  $('head').append("<link rel='stylesheet' type='text/css' href='"+ styleSheetUrl + "'>");

  iframeHtml = autoTestTemplates["autotest/templates/iframe"]()
  stepsHtml = autoTestTemplates["autotest/templates/steps_list"]()

  $("body").prepend(iframeHtml)
  $("body").append(stepsHtml)

  window.autoTestRecorder = new AutoTestRecorder window.projectId
  window.autoTestApiUrl = window.apiUrl
  window.autoTestAuthToken = window.authToken

  window.addEventListener "message", (e)->
    data = e.data
    AutoTestPostMessageHandler.perform(data.messageType, data.featureId)

  postMessageToIframe = (message)->
    console.log("posting")
    iframe = document.getElementById("autotest-iframe").contentWindow
    iframe.postMessage(message, window.apiUrl)

  window.postMessageToIframe = postMessageToIframe

  autoTestRecorder.start()
