class @AutoTestScenario
  constructor: (@projectId, @featureId, @name, @startUrl) ->
    @authToken = window.autoTestAuthToken
    @apiUrl = window.autoTestApiUrl
    @sessionStorage = window.sessionStorage
    @id = ""
    @autoTestSteps = []

  save: ->
    autoTestScenario = ""
    if @id == ""
      that = this
      $.ajax(@apiUrl + '/api/v1/projects/' + @projectId + '/features/' + @featureId + '/scenarios',
        type: 'POST',
        dataType: "json",
        data: {scenario: {name: this.name, start_url: this.startUrl}},
        async: false,
        beforeSend: (xhr, settings) ->
          xhr.setRequestHeader('Authorization', "Token token=\"#{that.authToken}\"")
        success: (data, textStatus, jqXHR) ->
          console.log("Added scenario #{data.scenario.name} - #{data.scenario.id}")
          autoTestScenario = new AutoTestScenario data.scenario.project_id, data.scenario.feature_id, data.scenario.name, @startUrl
          autoTestScenario.id = data.scenario.id
        error:  (jqXHR, textStatus, errorThrown) ->
          console.log("error thrown")
      )
    else
      autoTestScenario = this
    return  autoTestScenario

  steps: ->
    autoTestSteps = AutoTestStep.findAll(@projectId, @featureId, @id)
    return autoTestSteps

  addStep: (type, locator, text) ->
    autoTestStep = AutoTestStep.create this.featureId, this.id, type, locator, text
    @autoTestSteps.push(autoTestStep)
    $("#step-count").text("#{@autoTestSteps.length} steps")
    stepNumber = (@autoTestSteps.length-1).toString()
    $("#view-steps ul").append("<li step-number=#{stepNumber}>#{autoTestStep.to_s}</li>")
    return true

  # Attributes is an object
  @create: (projectId, featureId, name, startUrl) ->
    scenario = new AutoTestScenario projectId, featureId, name, startUrl
    autoTestScenario = scenario.save()
    return autoTestScenario

  @find: (projectId, featureId, id) ->
    console.log("finding scenario")
    apiUrl = window.autoTestApiUrl
    authToken = window.autoTestAuthToken
    autoTestScenario = ""
    $.ajax("#{apiUrl}/api/v1/projects/#{projectId}/features/#{featureId}/scenarios/#{id}",
        type: 'GET',
        dataType: 'json',
        async: false,
        beforeSend: (xhr, settings) ->
          xhr.setRequestHeader('Authorization', "Token token=\"#{authToken}\"")
        success: (data) ->
          autoTestScenario = new AutoTestScenario(data.scenario.project_id, data.scenario.feature_id, data.scenario.name, data.scenario.start_url)
          autoTestScenario.id = data.scenario.id
          autoTestScenario.autoTestSteps = autoTestScenario.steps()
    )
    return autoTestScenario
