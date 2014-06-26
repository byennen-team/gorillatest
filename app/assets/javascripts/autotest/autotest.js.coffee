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
        Autotest.authToken =  scripts[i].getAttribute("data-api-key")
        if scripts[i].getAttribute("data-api-url")
          Autotest.apiUrl = scripts[i].getAttribute("data-api-url")
        else
          Autotest.apiUrl = "https://www.gorillatest.com"
        break
      i++
    params = $.url(window.location.href).param()
    window.sessionStorage.removeItem("autoTest.showRecorder")

    if params["developer"] == "true" || window.sessionStorage.getItem("autoTest.developerPlaying") == "1"
      Autotest.developerMode = true
      if @hasScenario(params)
        @setScenario(params)
      else
        alert("You must provide a scenario id to test.")
    else if params["gorilla-recording"] == "true"
      window.sessionStorage.setItem("autoTest.showRecorder", "true")


Autotest.initialize()

$(document).ready ->
  if Autotest.parent == "iframe"
    iframeIndexView = new Autotest.Views.IframeIndex({el: ".recording-bar"})
  else
    styleSheetUrl = Autotest.apiUrl + "/assets/recorder.css"
    $('head').append("<link rel='stylesheet' type='text/css' href='"+ styleSheetUrl + "'>");
    console.log("Developer mode is #{Autotest.developerMode}")
    if Autotest.developerMode == true
      $("body").css("padding-top", "55px")
      devIframeHtml = JST["autotest/templates/developer"]
      devMouseHtml = JST["autotest/templates/developer_mouse"]
      window.autoTestDeveloper = true
      $("body").append(devMouseHtml)
      $("body").append(devIframeHtml)
      scenario = new Autotest.Models.Scenario({id: Autotest.developerScenarioId})
      $("iframe#autotest-dev-iframe").on "loadComplete", ->
        scenario.fetch({
          success: (model, response, options) ->
            Autotest.currentScenario = model
            console.log("have scenario")
            developerIndex = new Autotest.Views.DeveloperIndex
            Autotest.Messages.Parent.post({messageType: "showScenario", projectName: Autotest.currentScenario.get("projectName"), scenarioName: Autotest.currentScenario.get("name")})
            if window.sessionStorage.getItem("autoTest.developerPlaying") == "1"
              Autotest.Messages.Parent.post({messageType: "resumePlayback"})
          error: ->
            alert("that scenario doesn't exist")
        })
    else if window.sessionStorage.getItem("autoTest.showRecorder") == "true" || sessionStorage.getItem("autoTestRecorder.isRecording") == "true"
      $("body").css("padding-top", "55px")
      iframeHtml = JST["autotest/templates/iframe"]()
      stepsHtml = JST["autotest/templates/steps_list"]()
      overlay = JST["autotest/templates/loading_overlay"]()
      $("body").append(iframeHtml)
      $("body").append(stepsHtml)
      $("body").append(overlay) if sessionStorage.getItem("autoTestRecorder.isRecording") == "true"
      window.autoTestRecorder = new AutoTestRecorder window.projectId
      $("iframe#autotest-iframe").on "loadComplete", ->
        window.autoTestRecorder.start()
