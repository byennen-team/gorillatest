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
//= require autotest/iframe_controller

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

window.postParentMessage = (message)->
parent.postMessage(message, document.referrer)

window.autoTestRecorder = new AutoTestRecorder window.projectId
window.autoTestApiUrl = window.apiUrl
window.autoTestAuthToken = window.authToken

