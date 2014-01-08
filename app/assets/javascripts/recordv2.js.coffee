//= require jquery
//= require jquery_ujs

scripts = document.getElementsByTagName("script")
i = 0
l = scripts.length

while i < l
  if scripts[i].src is "http://autotest.dev/assets/recordv2.js"
    projectId = scripts[i].getAttribute("data-project-id")
    authToken =  scripts[i].getAttribute("data-auth")
    break
  i++

class AutoTestRecorder
  constructor: (@authToken, @projectId) ->
    @baseUrl = "http://autotest.dev/scenarios"
    @steps = []
    @isRecording = false
    @currentScenario = ""

  start: ->

  record: ->
    # Collect actions toa JSON structure
    @isRecording = true
    # Add is recording to cookies so we can see if we are currently recording
    # on redirects
    $("a").bind("click", (event) ->
       event.preventDefault();
       console.log("href is #{$(this).attr('href')}")
       console.log("id is #{$(this).attr('id')}")
       AutoTestRecorder.addStep('click', {"type": "id", value: $(this).attr("id")}, "")
    )
    return

  addScenario: ->
    name = "Test Scenario"
    url = window.location.href
    console.log("added scenario")
    autoTestScenario = new AutoTestScenario url, name
    autoTestScenario.save()
    # Add scenario to cookies so we can see that we are recording upon redirects

  addStep: (type, locator, text) ->
    autoTestStep = new AutoTestStep type, locator, text
    @steps.pus('autoTestStep')

class AutoTestScenario
  constructor: (@currentUrl, @name) ->
    @baseUrl = "http://autotest.dev/scenarios"
    console.log("Initialized new scenario")

  save: ->
    console.log("name is #{@name}")
    console.log("url is #{@currentUrl}")
    return true

class AutoTestStep
  # a locator is actually a hash.
  constructor: (@type, @locator, @text) ->




window.autoTestRecorder = new AutoTestRecorder authToken, projectId
autoTestRecorder.start()