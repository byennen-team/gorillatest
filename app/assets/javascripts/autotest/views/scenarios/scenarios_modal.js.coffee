class Autotest.Views.ScenariosModal extends Backbone.View

  el: $(".autotest-modal-content")

  events: {
    "click #start-recording" : "createScenario"
  }

  createScenario: (e) ->
    console.log("Saving the scenario")
    console.log(Autotest.currentFeature.url())
    scenarios = new Autotest.Collections.Scenarios(Autotest.currentFeature)
    scenarios.create({name: $("input#scenario_name").val(),start_url: window.location.href, window_x: $(window).width(), window_y: $(window).height()},
      success: (model, response, options) ->
        model.setCurrentScenario()
        window.autoTestRecorder.record()
        $("#scenario-modal").bPopup().close()
        model.addStep({event_type: "get", locator_type: '', locator_value: '', text: window.location.href})
        window.postMessageToIframe({messageType: "startRecording", message: {scenarioName: model.get('name'), featureName: Autotest.currentFeature.get('name')}})
      error: (model, response, options) ->
        if $("#scenario-modal-errors").length == 0
          $("#scenario-modal .autotest-modal-body").append("<ul id='scenario-modal-errors'></ul>")
        $("#scenario-modal-errors").html('')
        $.each response.responseJSON.errors, (i, message) ->
          $("#scenario-modal-errors").append("<li class='text-danger'>#{message}</li>")
    )