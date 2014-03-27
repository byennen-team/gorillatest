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
          Autotest.apiUrl = "http://autotest.io"
        break
      i++
    params = $.url(window.location.href).param()
    if params["developer"] == "true"
      Autotest.developerMode = true
      if params["scenario_id"] && params["feature_id"]
        Autotest.developerScenarioId = params["scenario_id"]
        Autotest.developerFeatureId = params["feature_id"]
      else
        alert("You must provide a feature id and a scenario id to test.")


Autotest.initialize()

$(document).ready ->
  # Autotest.features = new Autotest.Collections.Features
  # Autotest.features.fetch()
  #Autotest.featureIndex = new Autotest.Views.FeaturesIndex({collection: Autotest.features})
  if Autotest.parent == "iframe"
    Autotest.features = new Autotest.Collections.Features
    Autotest.features.fetch()
    Autotest.featureIndex = new Autotest.Views.FeaturesIndex({collection: Autotest.features})
    iframeIndexView = new Autotest.Views.IframeIndex({el: ".recording-bar"})
  else
    styleSheetUrl = Autotest.apiUrl + "/assets/application/recorder.css"
    $('head').append("<link rel='stylesheet' type='text/css' href='"+ styleSheetUrl + "'>");
    console.log("Developer mode is #{Autotest.developerMode}")
    if Autotest.developerMode == true
      devIframeHtml = JST["autotest/templates/developer"]
      window.autoTestDeveloper = true
     # window.autoTestPlayback = new AutotestPlayback window.projectId, window.scenarioId
      $("body").prepend(devIframeHtml)
      feature = new Autotest.Models.Feature({id: Autotest.developerFeatureId})
      feature.fetch({
        success: (model, response, options) ->
          Autotest.currentFeature = model
          scenario = new Autotest.Models.Scenario({id: Autotest.developerScenarioId, url: "#{model.url()}/scenarios/#{Autotest.developerScenarioId}"})
          scenario.fetch({
            success: (model, response, options) ->
              Autotest.currentScenario = model
              console.log("have scenario")
              developerIndex = new Autotest.Views.DeveloperIndex
              Autotest.Messages.Parent.post({messageType: "showScenario", featureName: Autotest.currentFeature.get("name"), scenarioName: Autotest.currentScenario.get("name")})
            error: ->
              alert("that scenario doesn't exist")
          })
        error: ->
          alert("that feature doesn't exist")
      })

    else
      iframeHtml = JST["autotest/templates/iframe"]()
      stepsHtml = JST["autotest/templates/steps_list"]()
      $("body").prepend(iframeHtml)
      $("body").append(stepsHtml)
      window.autoTestRecorder = new AutoTestRecorder window.projectId
      Autotest.features = new Autotest.Collections.Features
      Autotest.features.fetch(
        success: ->
          window.autoTestRecorder.start()
          Autotest.featureIndex = new Autotest.Views.FeaturesIndex({collection: Autotest.features})

        error: ->
          alert("Could not start recorder")
      )
      # Autotest.featureIndex = new Autotest.Views.FeaturesIndex({collection: Autotest.features})



