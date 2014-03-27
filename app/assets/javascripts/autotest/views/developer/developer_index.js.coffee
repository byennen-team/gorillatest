class Autotest.Views.DeveloperIndex extends Backbone.View

  el: "#button-bar"
  events: {
    "click #play": "play"
    "click #stop": "stop"
    "click #pause": "pause"
    "click #forward": "forward"
    "click #backward": "backward"
  }

  showCurrentScenario: (featureName, scenarioName) ->
    console.log("calling show current scenario")
    scenario = "&nbsp;&nbsp;<strong>Developer Mode:</strong> #{featureName} - #{scenarioName}"
    $("#current-scenario").html(scenario)
    $("#current-scenario").show()

  showPlayStep: (message) ->
    console.log("Playing STep: #{message}")

  play: ->
    console.log("play clicked")
    @showHidePlayButtons()
    @postMessage({messageType: "startPlayback"})

  stop: ->
    @showHidePlayButtons()
    @postMessage({messageType: "stopPlayback"})

  pause: ->
    @showHidePlayButtons
    @postMessage({messageType: "pausePlayback"})

  forward: ->
    @postMessage({messageType: "forwardPlayback"})

  backward: ->
    @postMessage({messageType: "backwardPlayback"})

  showHidePlayButtons: ->
    console.log("showing play or hiding it")
    if $("#play").is(":visible")
      $("#play").hide()
      $("#pause").show()
      $("#stop").show()
    else
      $("#stop").hide()
      $("#pause").hide()
      $("#play").show()

  postMessage: (message) ->
    Autotest.Messages.Iframe.post(message)
