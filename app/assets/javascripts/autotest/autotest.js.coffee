window.autoTestTemplates = {}
window.Autotest =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  currentFeature: null
  initialize: ->
    scripts = document.getElementsByTagName("script")
    i = 0
    l = scripts.length

    while i < l
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
  Autotest.featureIndex = new Autotest.Views.FeaturesIndex({collection: Autotest.features})
  Autotest.features.fetch()
