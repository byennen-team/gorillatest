class Autotest.Steps.ClickStep extends Autotest.Steps.TargetedStep

  constructor: (@step) ->
    super(@step)

  mood: "click"

  perform: (workspace) ->
    if @$target.length isnt 1
      return false

    utils.eventFire(@$target, "mouseenter")
    utils.eventFire(@$target, "mouseover")
    utils.eventFire(@$target, "click")
    utils.eventFire(@$target, "mousedown")
    utils.eventFire(@$target, "mouseup")

    return @$target

Autotest.Developer.Steps.add("clickElement", (step) ->
  clickStep = new Autotest.Steps.ClickStep(step)
  return clickStep.perform()
)