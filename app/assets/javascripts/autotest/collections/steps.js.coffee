class Autotest.Collections.Steps extends Backbone.Collection

  model: Autotest.Models.Step

  initialize: (scenario) ->
    this.url = "#{scenario.url()}/steps"
    @speed = 1000
    @selected = null
    @performing = null
    @failedSteps = []

  play: ->
    # $.each(this.models, (i, s) ->
    #   @currentStep = 0
    window.sessionStorage.setItem("autoTest.developerPlaying", "1")
    currentStep = window.sessionStorage.getItem("autoTest.developerStep")
    if currentStep != null
      @select(@at(@indexOf(currentStep) + 1))
    else
      @select(@first()) unless @selected
    @interval = setInterval( =>
      try
        allDone = @performCurrentStep()
        if allDone
          @select("STEPS DONE")
          @stop()
          console.log("DONE")
          @trigger 'success'
        # else
        # @selected.getTarget?(@workspace)
      catch error
        @errorMessage = error.message
        @select(@ERROR)
        @stop()
        @trigger 'failure'
        throw error
    , @speed)

  stop: ->
    clearInterval(@interval)
    Autotest.Messages.Parent.post({messageType: "stopPlayback"})


  pause: ->

  next: ->

  previous: ->

  performCurrentStep: ->
    Autotest.Messages.Parent.post({messageType: "playStep", message: "Playing: #{@selected.get('to_s')}"})
    allDone = true
    unless @selected
        return allDone

    @performing = true
    if @selected.get("event_type") != "get"
      outcome = @selected.perform()
    else
      outcome = true

    window.sessionStorage.setItem("autoTest.developerStep", @at(@indexOf(@selected)))
    @performing = false

    if outcome  # the step passed
        @add(@pendingSteps)
        @pendingSteps = []
    else
        @incrementFailures()
        @pendingSteps = []
        # return (not allDone)

    next = @at(@indexOf(@selected) + 1)

    if next?
        @select(next)
        return (not allDone)
    else
        return allDone

  incrementFailures: ->
    console.log("recording failure")
    @failedSteps.push(@selected)

  select: (@selected) ->


