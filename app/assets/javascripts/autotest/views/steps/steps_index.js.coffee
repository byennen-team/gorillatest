class Autotest.Views.Steps extends Backbone.View

  initialize:->
    this.listenTo(this.collection, "add", this.render)

  render: (model, collection, options) ->
    step = model
    length = this.collection.models.length
    window.postMessageToIframe({messageType: "stepAdded", message: {stepCount: length} })
    stepNumber = length.toString()
    $("#autotest-view-steps ul").append("<li step-number=#{stepNumber}>#{model.get('to_s')}</li>")

