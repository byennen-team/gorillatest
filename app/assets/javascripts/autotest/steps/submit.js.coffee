class Autotest.Steps.SubmitStep extends Autotest.Steps.TargetedStep

  constructor: (@step) ->
    super(@step)

  perform: () ->
    if @$target.length isnt 1
      return false

    @$target.click()
    return @$target

Autotest.Developer.Steps.add("submitElement", (step) ->
  submitStep = new Autotest.Steps.SubmitStep(step)
  submitStep.perform()
)
