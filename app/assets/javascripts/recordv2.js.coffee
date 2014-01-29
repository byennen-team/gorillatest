//= require autotest/recorder
//= require autotest/feature
//= require autotest/scenario
//= require autotest/step
//= require autotest/event
//= require autotest/locator_builder
//= require autotest/locator
//= require gui_controller
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
  window.autoTestRecorder = new AutoTestRecorder window.projectId
  window.autoTestApiUrl = window.apiUrl
  window.autoTestAuthToken = window.authToken
  console.log("authtoken is #{window.autoTestAuthToken}")
  if $(".test-form").length > 0
    $(".test-form").attr("action", "/test/form_post?project_id=#{window.projectId}")
  autoTestRecorder.start()

  options = new Array
  $.each autoTestRecorder.features, (k, v) ->
    options.push "<option value='#{v.id}'>#{v.name}</option>"
  $("select#features").html("<option value=''>Select a Feature...</option>" + options.join(''))
  $("select#features").bind "change", ->
    window.autoTestRecorder.setCurrentFeature($(this).val()) if $(this).val().length > 0

  $(".recording-bar .modal").on "show.bs.modal", (e) ->
    $(this).css("height", "300px").css("overflow-y", "visible")


  $(".recording-bar .modal").on "hidden.bs.modal", (e) ->
    $(this).css("height", "0px").css("overflow-y", "hidden")
