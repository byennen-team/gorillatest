class Autotest.Collections.Steps extends Backbone.Collection

  model: Autotest.Models.Step

  initialize: (scenario) ->
    this.url = "#{scenario.url()}/steps"