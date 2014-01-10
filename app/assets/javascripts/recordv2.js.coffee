//= require jquery
//= require jquery_ujs
//= require autotest/recorder
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
    break
  i++

window.autoTestRecorder = new AutoTestRecorder authToken, projectId
autoTestRecorder.start()
