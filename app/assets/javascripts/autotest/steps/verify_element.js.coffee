class Autotest.Steps.VerifyElementStep extends Autotest.Steps.TargetedStep
  constructor: (@step) ->
    super(@step)

  mood: "look"

  perform: ->
    if @$target.length is 0
      return false

    # Only check for expected text content if a string was passed
    if @text?
      if @$target.is('input')
        value = @$target.val()
      else
        value = @$target.text()

      matched = value.indexOf(@text) > -1

      if matched
        @$target.css("outline", "1px dashed green")
        return @$target
      else
        @$target.css("outline", "1px dashed red")
        return false
    else
      return @$target

Autotest.Developer.Steps.add("verifyElementPresent", (step) ->
  verifyElementStep = new Autotest.Steps.VerifyElementStep(step)
  return verifyElementStep.perform()
)
