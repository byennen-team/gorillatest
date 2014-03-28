class Autotest.Steps.SelectStep extends Autotest.Steps.TargetedStep

  constructor: (@step) ->
    super(@step)

  mood: 'look'

  perform: ->
    if @$target.length isnt 1
      return false
    @$target.val(@text)
    if @$target.val() == null
      return false

    return @$target

Autotest.Developer.Steps.add("setElementSelected", (step) ->
  selectStep = new Autotest.Steps.SelectStep(step)
  selectStep.perform()
)
