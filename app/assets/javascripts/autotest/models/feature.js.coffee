class Autotest.Models.Feature extends Backbone.Model
  urlRoot : "#{Autotest.apiUrl}/api/v1/features"

  # initialize: ->
  #   var self = this
  #   this.scenarios = new Scenarios(this.get('scenarios'));
  #   this.posts.url = function () { return self.url() + '/posts'; }; }

  setCurrentFeature: ->
    Autotest.currentFeature = this
    window.sessionStorage.setItem("autoTestRecorder.currentFeature", this.id)
