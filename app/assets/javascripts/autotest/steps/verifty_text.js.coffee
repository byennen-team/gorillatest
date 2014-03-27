class Autotest.Steps.VerifyTextStep extends Autoest.Steps.TargetedStep

  constructor: (@step) ->
    super(@step)

  mood: "look"

  perform: ->

Autotest.Developer.Steps.add("verifyText", (step) ->
  verifyTextStep = new Autotest.Steps.VerifyTextStep(step)
  return verifyTextStep.perform()
)