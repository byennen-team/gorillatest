class Autotest.Views.ScenariosIndex extends Backbone.View

  showCreateModal: ->
    options = {width: "400px", height: "400px", margin: "0 auto", "overflow-y": "auto", wrapperId: 'scenario-modal'}
    autoTestGuiController.renderModal("scenario_modal", options, ->
      $("input#scenario_name").bind "blur", ->
        if $(this).val().length > 0
          $("button#start-recording").removeAttr("disabled")
        else
          $("button#start-recording").attr("disabled", "disabled")
        return
      )
    return

  startRecording: (message) ->
    $("#current-scenario").text("Currently recording #{message.featureName} - #{message.scenarioName}")
    $("#current-scenario").show()
    $("button#record").hide()
    $("button#stop-recording").show()
    $("#start-text-highlight").show()
    $("select#features").attr("disabled", "disabled")
    $("select#features").hide()
    $("button#add-feature").hide()
    $("#step-count").show()
    $(".recording-bar").addClass("recording")
    $("#step-count-text").show()

