class Autotest.Views.Steps extends Backbone.View

  # el: $("ul#autotest-steps")

  initialize: (options)->
    if options && options.collection
      this.listenTo(this.collection, "sync", this.render)

  render: (model, collection, options) ->
    window.postMessageToIframe({messageType: "stepAdded", message: {stepCount: collection.length} })
    _this = this
    $.each Autotest.currentSteps.models, (i, step) ->
      $("ul#autotest-steps").append("<li step-number=#{i}>#{step.get('to_s')}</li>")

    # step = model
    # length = this.collection.models.length
    # stepNumber = length.toString()
    # $("#autotest-view-steps ul").append("<li step-number=#{stepNumber}>#{model.get('to_s')}</li>")

  view: ->
    if $("#autotest-view-steps").is(':visible')
      $("#autotest-view-steps").slideUp()
    else
      $("#autotest-view-steps").slideDown()

  remove: ->
