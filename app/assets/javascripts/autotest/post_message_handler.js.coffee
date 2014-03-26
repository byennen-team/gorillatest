# class @AutoTestPostMessageHandler

#   @handlerMap = {}
#   @add: (event, f) ->
#     @handlerMap[event] = f
#     return

#   @perform: (event, featureId) ->
#     if event != undefined
#       @handlerMap[event].call(null, featureId)


# AutoTestPostMessageHandler.add("setFeature", (featureId) ->
#   Autotest.features.fetch()
#   feature = Autotest.features.findWhere({id: featureId})
#   feature.setCurrentFeature()
#   Autotest.currentFeature = feature
# )

# AutoTestPostMessageHandler.add("recordClick", (featureId) ->
#   console.log("Showing scenario modal")
#   scenarioIndex = new Autotest.Views.ScenariosIndex
#   scenarioIndex.showCreateModal()
#   new Autotest.Views.ScenariosModal({el: $(".autotest-modal-content")})
# )

# AutoTestPostMessageHandler.add("addFeature", (featureId) ->
#   Autotest.featureIndex.showCreateModal()
#   new Autotest.Views.FeaturesModal({el: $(".autotest-modal-content")})
# )

# AutoTestPostMessageHandler.add("viewSteps", ->
#   autoTestGuiController.viewSteps()
# )

# AutoTestPostMessageHandler.add("stopRecording", (featureId) ->
#   autoTestRecorder.stop()
# )

# AutoTestPostMessageHandler.add("selectElement", (featureId) ->
#  autoTestGuiController.startElementHighlight()
# )

# AutoTestPostMessageHandler.add("stopSelectElement", (featureId) ->
#   autoTestGuiController.stopElementHighlight()
# )