class @AutoTestStep
  # a locator is actually a hash.
  constructor: (@featureId, @scenarioId, @type, @locator, @text) ->
    @authToken = window.autoTestAuthToken
    @apiUrl = window.autoTestApiUrl
    @projectId = window.projectId
    @id = ""

  save: ->
    autoTestStep = ""
    if @id == ""
      that = this
      $.ajax(@apiUrl + '/api/v1/projects/' + @projectId + '/features/' + @featureId + '/scenarios/' + @scenarioId + '/steps',
        type: 'POST',
        dataType: "json",
        data: {step: {event_type: this.type, locator_type: this.locator.type, locator_value: this.locator.value, text: this.text}},
        async: false,
        beforeSend: (xhr, settings) ->
          xhr.setRequestHeader('Authorization', "Token token=\"#{that.authToken}\"")
        success: (data, textStatus, jqXHR) ->
          console.log("Added step - #{data.step.event_type} for #{data.step.locator_type} - #{data.step.locator_value}")
          autoTestStep = new AutoTestStep data.step.feature_id, data.step.scenario_id, data.step.event_type, {type: data.step.locator_type, value: data.step.locator_value}, data.step.text
          autoTestStep.id = data.step.id
        error:  (jqXHR, textStatus, errorThrown) ->
          console.log("error thrown")
      )
    else
      autoTestStep = this
    return  autoTestStep

  @findAll: (projectId, featureId, scenarioId) ->
    apiUrl = window.autoTestApiUrl
    authToken = window.autoTestAuthToken
    steps = new Array
    $.ajax(apiUrl + "/api/v1/projects/#{@projectId}/features/#{featureId}/scenarios/#{scenarioId}/steps",
      type: 'GET',
      dataType: 'json',
      async: false,
      beforeSend: (xhr, settings) ->
        xhr.setRequestHeader('Authorization', "Token token=\"#{authToken}\"")
      success: (data) ->
        $.each(data.steps, (i, data) ->
          autoTestStep = new AutoTestStep(data.feature_id, data.scenario_id, data.event_type, {type: data.locator_type, value: data.locator_value}, data.text)
          autoTestStep.id = data.id
          steps.push(autoTestStep)
        )
    )
    return steps

  @find: (scenarioId, id) ->

  @create: (featureId, scenarioId, type, locator, text) ->
    step = new AutoTestStep featureId, scenarioId, type, locator, text
    autoTestStep = step.save()
    return autoTestStep


