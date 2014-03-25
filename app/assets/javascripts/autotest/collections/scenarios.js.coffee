class Autotest.Collections.Scenarios extends Backbone.Collection
  # url:   "#{Autotest.apiUrl}/api/v1/features/#{Autotest.currentFeature.id}/scenarios"
  model: Autotest.Models.Scenario

  initialize: (feature) ->
    this.url = "#{feature.url()}/scenarios"