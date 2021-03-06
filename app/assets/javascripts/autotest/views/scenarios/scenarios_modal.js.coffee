class Autotest.Views.ScenariosModal extends Backbone.View

  el: $(".autotest-modal-content")

  events: {
    "click #start-recording" : "createScenario"
  }

  createScenario: (e) ->
    $("#start-recording").attr("disabled", true)
    scenarios = new Autotest.Collections.Scenarios()
    scenarioAttrs = {
                     name: $("input#scenario_name").val(),
                     start_url: window.location.href.replace("&gorilla-recording=true","").replace("?gorilla-recording=true",""),
                     window_x: $(window).width(), window_y: $(window).height()
                    }
    scenarios.create(scenarioAttrs,
      success: (model, response, options) ->
        $("#start-recording").attr("disabled", false)
        model.setCurrentScenario()
        model.steps()
        window.autoTestRecorder.record()
        $("#scenario-modal").bPopup().close()
        stepIndex = new Autotest.Views.StepIndex({collection: model.steps()})
        model.addStep({event_type: "get", locator_type: '', locator_value: '', text: window.location.href.replace("&gorilla-recording=true","").replace("?gorilla-recording=true","")})
        Autotest.Messages.Parent.post({messageType: "startRecording", message: {scenarioName: model.get('name')}})
      error: (model, response, options) ->
        $("#start-recording").attr("disabled", false)
        if $("#scenario-modal-errors").length == 0
          $("#scenario-modal .autotest-modal-body").append("<ul id='scenario-modal-errors'></ul>")
        $("#scenario-modal-errors").html('')
        $.each response.responseJSON.errors, (i, message) ->
          $("#scenario-modal-errors").append("<li class='text-danger'>#{message}</li>")
    )
