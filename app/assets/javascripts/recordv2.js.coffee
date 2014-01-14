//= require jquery
//= require jquery_ujs
//= require autotest/recorder
//= require autotest/feature
//= require autotest/scenario
//= require autotest/step
//= require_self

scripts = document.getElementsByTagName("script")
i = 0
l = scripts.length

while i < l
  if scripts[i].src is "http://autotest.dev/assets/recordv2.js"
    projectId = scripts[i].getAttribute("data-project-id")
    authToken =  scripts[i].getAttribute("data-auth")
    if scripts[i].getAttribute("data-api-url") 
    	apiUrl = scripts[i].getAttribute("data-api-url")
    else
    	apiUrl = "http://autotest.io"
    break
  i++

window.autoTestRecorder = new AutoTestRecorder projectId

# Need to figure out how to namespace these so they don't pollute global windows vars - jkr
$(document).ready () ->
  window.autoTestRecorder = new AutoTestRecorder projectId  
  window.autoTestApiUrl = apiUrl
  window.autoTestAuthToken = authToken
  autoTestRecorder.start()
