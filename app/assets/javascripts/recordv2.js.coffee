//= require jquery
//= require jquery_ujs
//= require autotest/recorder
//= require autotest/feature
//= require autotest/scenario
//= require autotest/step
//= require gui_controller
//= require_self

scripts = document.getElementsByTagName("script")
i = 0
l = scripts.length

while i < l
  if scripts[i].src is "http://autotest.dev/assets/recordv2.js"
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
  window.autoTestRecorder = new AutoTestRecorder window.projectId
  window.autoTestApiUrl = window.apiUrl
  window.autoTestAuthToken = window.authToken
  autoTestRecorder.start()
