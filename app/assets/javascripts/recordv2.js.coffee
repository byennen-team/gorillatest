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
    if window.sessionStorage
      @sessionStorage = window.sessionStorage
    else
      alert("You can't record on this browser")
    @isRecording = @sessionStorage.getItem("isRecording") == "true" ? true : false
    @currentScenario = null

  start: ->
    if @isRecording == true
      console.log("You are presently recording a scenario")
      # load the current scenario
      scenarioId = @sessionStorage.getItem("currentScenario")
      if scenarioId != null
        @currentScenario = AutoTestScenario.find(scenarioId)
      # Record step of redirected to -> current window location href
      this.addStep("redirect", {}, window.location.href)

  record: ->
    # Collect actions toa JSON structure
    @isRecording = true
    @sessionStorage.setItem("isRecording", @isRecording)
    $("a").bind("click", (event) ->
       event.preventDefault();
       console.log("href is #{$(this).attr('href')}")
       console.log("id is #{$(this).attr('id')}")
    )
    return

  stop: ->
    @isRecording = false
    @sessionStorage.setItem("isRecording", false)

  addScenario: (name) ->
    autoTestScenario = new AutoTestScenario name, window.location.href
    @currentScenario = autoTestScenario.create()
    @sessionStorage.setItem("currentScenario", @currentScenario.id)
    # Add scenario to cookies so we can see that we are recording upon redirects

  addStep: (type, locator, text) ->
    console.log("add step of type - #{type}")
    console.log("add step text - #{text}")
    autoTestStep = new AutoTestStep type, locator, text
    @steps.push('autoTestStep')

class AutoTestScenario
  constructor: (@name, @startUrl) ->
    @baseUrl = "http://autotest.dev/scenarios"
    console.log("Initialized new scenario")

  save: ->
    console.log("name is #{@name}")
    console.log("url is #{@currentUrl}")
    return true

  create: ->
    @id = 123
    return this

  # this needs to find the real scenario. Probably needs a model backing.
  @find: (id) ->
    autoTestScenario = new AutoTestScenario("test scenario", window.location.href)
    autoTestScenario.id = 123
    return autoTestScenario

class AutoTestStep
  # a locator is actually a hash.
  constructor: (@type, @locator, @text) ->



window.autoTestRecorder = new AutoTestRecorder authToken, projectId
autoTestRecorder.start()