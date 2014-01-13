class @AutoTestStep
  # a locator is actually a hash.
  constructor: (@authToken, @scenarioId, @type, @locator, @text) ->
    @id = ""

  save: ->
    autoTestStep = ""
    if @id == ""
      that = this
      $.ajax('http://autotest.dev/api/v1/projects/' + @projectId + '/scenarios/' + @scenarioId + '/steps',
        type: 'POST',
        dataType: "json",
        data: {step: {event_type: this.type, locator_type: this.locator.type, locator_value: this.locator.value, text: this.text}},
        async: false,
        beforeSend: (xhr, settings) ->
          xhr.setRequestHeader('Authorization', "Token token=\"#{that.authToken}\"")
        success: (data, textStatus, jqXHR) ->
          autoTestStep = new AutoTestStep that.authToken, data.step.scenario_id, data.step.event_type, {type: data.step.locator_type, value: data.step.locator_value}, this.text
          autoTestStep.id = data.step.id
        error:  (jqXHR, textStatus, errorThrown) ->
          console.log("error thrown")
      )
    else
      autoTestStep = this
    return  autoTestStep

  @findAll: (authToken, scenarioId) ->
    steps = new Array
    $.ajax("http://autotest.dev/api/v1/projects/#{@projectId}/scenarios/#{scenarioId}/steps",
      type: 'GET',
      dataType: 'json',
      async: false,
      beforeSend: (xhr, settings) ->
        xhr.setRequestHeader('Authorization', "Token token=\"#{authToken}\"")
      success: (data) ->
        $.each(data.steps, (i, data) ->
          autoTestStep = new AutoTestScenario(authToken, data.scenario_id, data.event_type, {type: data.locator_type, value: data.locator_value}, data.text)
          autoTestStep.id = data.id
          steps.push(autoTestStep)
        )
    )
    return steps

  @find: (authToken, scenarioId, id) ->

  @create: (authToken, scenarioId, type, locator, text) ->
    step = new AutoTestStep authToken, scenarioId, type, locator, text
    autoTestStep = step.save()
    return autoTestStep


