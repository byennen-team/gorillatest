class Autotest.Views.StepIndex extends Backbone.View

  # el: $("ul#autotest-steps")

  initialize: (options)->
    if options && options.collection
      this.listenTo(this.collection, "sync", this.render)

  render: (model, collection, options) ->
    $("ul#autotest-steps").html("")
    $.each Autotest.currentSteps.models, (i, step) ->
      $("ul#autotest-steps").append("<li step-number=#{i}>#{step.get('to_s')}</li>")

  view: ->
    if $("#autotest-view-steps").is(':visible')
      $("#autotest-view-steps").slideUp()
    else
      $("#autotest-view-steps").slideDown()

  remove: ->
