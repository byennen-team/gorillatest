class Autotest.Models.Feature extends Backbone.Model
  urlRoot : "#{Autotest.apiUrl}/api/v1/features"

  setCurrentFeature: ->
    Autotest.currentFeature = this
    window.sessionStorage.setItem("autoTestRecorder.currentFeature", this.id)
