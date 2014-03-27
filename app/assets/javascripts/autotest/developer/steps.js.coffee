class Autotest.Developer.Steps

  @handleSteps = {}

  @add: (name, f) ->
    @handleSteps[name] = f

  @perform: (step) ->
    @handleSteps[step.get("event_type")].call(null, step)