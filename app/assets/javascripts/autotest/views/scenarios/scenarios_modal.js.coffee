class Autotest.Views.ScenariosModal extends Backbone.View

  el: $(".autotest-modal-content")

  events: {
    "click #start-recording" : "createScenario"
  }

  createScenario: (e) ->
    console.log("Saving the scenario")
    console.log(Autotest.currentFeature.url())
    $("#start-recording").attr("disabled", true)
    scenarios = new Autotest.Collections.Scenarios(Autotest.currentFeature)
    scenarios.create({url: "#{Autotest.currentFeature.url()}/scenarios", name: $("input#scenario_name").val(),start_url: window.location.href, window_x: $(window).width(), window_y: $(window).height()},
      success: (model, response, options) ->
        $("#start-recording").attr("disabled", false)
        model.setCurrentScenario()
        model.steps()
        window.autoTestRecorder.record()
        $("#scenario-modal").bPopup().close()
        model.addStep({event_type: "get", locator_type: '', locator_value: '', text: window.location.href})
        window.postMessageToIframe({messageType: "startRecording", message: {scenarioName: model.get('name'), featureName: Autotest.currentFeature.get('name')}})
      error: (model, response, options) ->
        $("#start-recording").attr("disabled", false)
        if $("#scenario-modal-errors").length == 0
          $("#scenario-modal .autotest-modal-body").append("<ul id='scenario-modal-errors'></ul>")
        $("#scenario-modal-errors").html('')
        $.each response.responseJSON.errors, (i, message) ->
          $("#scenario-modal-errors").append("<li class='text-danger'>#{message}</li>")
    )
