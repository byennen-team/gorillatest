class Autotest.Collections.Features extends Backbone.Collection
  url:   "#{Autotest.apiUrl}/api/v1/features"
  model: Autotest.Models.Feature