window.autoTestTemplates = {}
window.Autotest =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Messages: {}
  Developer: {}
  Steps: {}
  currentFeature: null
  currentScenario: null
  currentSteps: null
  parent: null
  developerMode: false
  hasScenario: (params)->
    if params["scenario_id"]
      hasIds = true
    else if window.sessionStorage.getItem("autoTest.developerScenario")
      hasIds = true
    return hasIds
  setScenario: (params)->
    Autotest.developerScenarioId = params["scenario_id"] || window.sessionStorage.getItem("autoTest.developerScenario")
  initialize: ->
    scripts = document.getElementsByTagName("script")
    i = 0
    l = scripts.length

    while i < l
      if (/iframe/).test(scripts[i].src)
        Autotest.parent = "iframe"
      else
        Autotest.parent = "recorder"

      if (/iframe/).test(scripts[i].src) || (/recordv2/).test(scripts[i].src)
        Autotest.projectId = scripts[i].getAttribute("data-project-id")
        Autotest.authToken =  scripts[i].getAttribute("data-auth")
        if scripts[i].getAttribute("data-api-url")
          Autotest.apiUrl = scripts[i].getAttribute("data-api-url")
        else
          Autotest.apiUrl = "http://gorillatest.com"
        break
      i++
    params = $.url(window.location.href).param()
    if params["developer"] == "true" || window.sessionStorage.getItem("autoTest.developerPlaying") == "1"
      Autotest.developerMode = true
      if @hasScenario(params)
        @setScenario(params)
      else
        alert("You must provide a scenario id to test.")


Autotest.initialize()

$(document).ready ->
  if Autotest.parent == "iframe"
    iframeIndexView = new Autotest.Views.IframeIndex({el: ".recording-bar"})
  else
    styleSheetUrl = Autotest.apiUrl + "/assets/application/recorder.css"
    $('head').append("<link rel='stylesheet' type='text/css' href='"+ styleSheetUrl + "'>");
    console.log("Developer mode is #{Autotest.developerMode}")
    if Autotest.developerMode == true
      devIframeHtml = JST["autotest/templates/developer"]
      devMouseHtml = JST["autotest/templates/developer_mouse"]
      window.autoTestDeveloper = true
      $("body").prepend(devMouseHtml)
      $("body").prepend(devIframeHtml)
      scenario = new Autotest.Models.Scenario({id: Autotest.developerScenarioId})
      scenario.fetch({
        success: (model, response, options) ->
          Autotest.currentScenario = model
          console.log("have scenario")
          developerIndex = new Autotest.Views.DeveloperIndex
          $("iframe").load ->
            Autotest.Messages.Parent.post({messageType: "showScenario", projectName: Autotest.currentScenario.get("projectName"), scenarioName: Autotest.currentScenario.get("name")})
            if window.sessionStorage.getItem("autoTest.developerPlaying") == "1"
              Autotest.Messages.Parent.post({messageType: "resumePlayback"})
        error: ->
          alert("that scenario doesn't exist")
      })
    else
      iframeHtml = JST["autotest/templates/iframe"]()
      stepsHtml = JST["autotest/templates/steps_list"]()
      $("body").prepend(iframeHtml)
      $("body").append(stepsHtml)
      window.autoTestRecorder = new AutoTestRecorder window.projectId
      Autotest.scenario = new Autotest.Models.Scenario({id: window.sessionStorage.getItem("autoTestRecorder.currentScenario")})
      Autotest.scenario.fetch(
        success: ->
          window.autoTestRecorder.start()
        error: ->
          alert("Could not start recorder")
      )



