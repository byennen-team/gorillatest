window.autoTestTemplates = {}
window.Autotest =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Messages: {}
  currentFeature: null
  currentScenario: null
  currentSteps: null
  parent: null
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

Autotest.initialize()

$(document).ready ->
  Autotest.features = new Autotest.Collections.Features
  Autotest.features.fetch()
  Autotest.featureIndex = new Autotest.Views.FeaturesIndex({collection: Autotest.features})
  if Autotest.parent == "iframe"
    Autotest.features = new Autotest.Collections.Features
    Autotest.features.fetch()
    Autotest.featureIndex = new Autotest.Views.FeaturesIndex({collection: Autotest.features})
    iframeIndexView = new Autotest.Views.IframeIndex({el: ".recording-bar"})
  else
    Autotest.features = new Autotest.Collections.Features
    Autotest.features.fetch(
      success: ->
        window.autoTestRecorder.start()
      error: ->
        alert("Could not start recorder")
    )
    # Autotest.featureIndex = new Autotest.Views.FeaturesIndex({collection: Autotest.features})



