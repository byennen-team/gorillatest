class Autotest.Collections.Scenarios extends Backbone.Collection

  url: "#{Autotest.apiUrl}/api/v1/scenarios"
  model: Autotest.Models.Scenario

  # initialize: (feature) ->
  #   this.feature = feature
    # this.url = "#{feature.url()}/scenarios"