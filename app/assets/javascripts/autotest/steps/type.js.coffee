class Autotest.Steps.TypeStep extends Autotest.Steps.TargetedStep

  constructor: (@step) ->
    super(@step)

  mood: "locate"

  perform: () ->
    if @$target.length isnt 1
      return false

    @$target.focus()
    if @$target.val().length > 0
      @$target.select()
      @$target.val("")
    for char in @text
      opts = {which: char.charCodeAt(0)}
      utils.eventFire(@$target, "keydown", opts)
      @$target.val("#{@$target.val()}#{char}")
      utils.eventFire(@$target, "keyup", opts)
      utils.eventFire(@$target, "keypress", opts)
    utils.eventFire(@$target, "change", opts)
    return @$target



Autotest.Developer.Steps.add("setElementText", (step) ->
  typeStep = new Autotest.Steps.TypeStep(step)
  return typeStep.perform()
)
