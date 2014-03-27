class @Autotest.Steps.TargetedStep
  constructor: (@step) ->
    @$target = @step.element()
    @text = @step.get("text")

  announcement: -> @step.to_s