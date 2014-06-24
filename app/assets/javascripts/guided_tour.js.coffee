$ ->
  # field :dashboard, type: Boolean, default: false
  # field :sample_project, type: Boolean, default: false
  # field :test_run, type: Boolean, default: false
  # field :test_runs_index, type: Boolean, default: false
  # field :project, type: Boolean, default: false
  # field :dashboard, type: Boolean, default: false

  guidedTourOptions = (options)->
    return {
      tipLocation: options.tipLocation || "bottom"
      startOffset: 0
      postRideCallback: (index, tip)->
        $.ajax
          data: {tour_name: options.tourName}
          url: "/tours"
          method: "PUT"
      # postStepCallback: (i, tip)->
      #   if $(this).joyride("paused")
      #     $("h1").unbind("click")
      #     $("h1").click ->
      #       console.log("h1 click")
      #       $(window).joyride('resume')
    }

  tourElements = [{id: "#dashboard-tour", tourName: "dashboard"},
                  {id: "#project-show-tour", tourName: "project"},
                  {id: "#test-run-tour", tourName: "test_run"},
                  {id: "#sample-project-tour", tourName: "sample_project"},
                  {id: "#test-runs-tour", tourName: "test_runs_index"}]

  _.each tourElements, (tourElement)->
    if $(tourElement.id).length > 0
      $.get "/tours", (tour)->
        if tour[tourElement.tourName] == false
          $(tourElement.id).joyride(guidedTourOptions({tourName: tourElement.tourName})).joyride()
