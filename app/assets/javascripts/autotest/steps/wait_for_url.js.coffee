class Autotest.Steps.WaitForUrlStep

  constructor: (@step) ->
    @url = @step.get("text")


  perform: ->
    if document.location.href == @url
      result = true
    else
      result = false
    return result

Autotest.Developer.Steps.add("waitForCurrentUrl", (step) ->
  waitForUrlStep = new Autotest.Steps.WaitForUrlStep(step)
  waitForUrlStep.perform()
)
