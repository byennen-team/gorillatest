class Autotest.Collections.Scenarios extends Backbone.Collection
  # url:   "#{Autotest.apiUrl}/api/v1/features/#{Autotest.currentFeature.id}/scenarios"
  model: Autotest.Models.Scenario

  url: ->
    return "#{this.feature.url()}/scenarios"

  urlRoot: ->
    "#{this.feature.url()}/scenarios"

  initialize: (feature) ->
    this.feature = feature
    # this.url = "#{feature.url()}/scenarios"