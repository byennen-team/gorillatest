class Autotest.Collections.Steps extends Backbone.Collection

  model: Autotest.Models.Step

  initialize: (scenario) ->
    this.url = "#{scenario.url()}/steps"
    @speed = 1000
    @selected = null
    @performing = null
    @failedSteps = []
    @allDone = false

  play: ->
    window.sessionStorage.setItem("autoTest.developerPlaying", "1")
    window.sessionStorage.setItem("autoTest.developerScenario", Autotest.developerScenarioId)
    window.sessionStorage.setItem("autoTest.developerFeature", Autotest.developerFeatureId)
    currentStepIndex = window.sessionStorage.getItem("autoTest.developerStep")
    console.log(@selected)
    if currentStepIndex != null
      @select(@at(parseInt(currentStepIndex) + 1))
    else
      @select(@first()) unless @selected
    __this = this
    Autotest.DeveloperInterval = window.setInterval( ->
      try
        console.log(allDone)
        allDone = __this.performCurrentStep()
        if allDone
          console.log("DONE")
          __this.trigger 'success'
          __this.stop()
          return
      catch error
        @errorMessage = error.message
        @select(@ERROR)
        @trigger 'failure'
        console.log("ERROR")
        @stop()
        throw error
     , @speed)

  stop: ->
    console.log(@selected)
    window.clearInterval(Autotest.DeveloperInterval)
    Autotest.DeveloperInterval = null
    @select(null)
    window.sessionStorage.removeItem("autoTest.developerPlaying")
    window.sessionStorage.removeItem("autoTest.developerStep")
    Autotest.Messages.Parent.post({messageType: "stopPlayback"})
    window.location.href = window.location.href


  pause: ->
    window.clearInterval(Autotest.DeveloperInterval)

  next: ->

  previous: ->

  performCurrentStep: ->
    allDoneCurrent = true
    unless @selected
        return allDoneCurrent

    Autotest.Messages.Parent.post({messageType: "playStep", message: "Playing: #{@selected.get('to_s')}"})
    @performing = true
    if @selected.get("event_type") != "get"
      outcome = @selected.perform()
    else
      outcome = true

    window.sessionStorage.setItem("autoTest.developerStep", @indexOf(@selected))
    @performing = false

    if !outcome  # the step passed
    #     # @add(@pendingSteps)
    #     # @pendingSteps = []
    # else
        @incrementFailures()
        @pendingSteps = []
        # return (not allDone)

    next = @at(@indexOf(@selected) + 1)

    if next?
        window.sessionStorage.setItem("autoTest.developerStep", @indexOf(@selected))
        @select(next)
        return (not allDoneCurrent)
    else
        return allDoneCurrent

  incrementFailures: ->
    console.log("recording failure")
    @failedSteps.push(@selected)

  select: (@selected) ->
    # @selected = @selected

