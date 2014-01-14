class @AutoTestScenario
  constructor: (@projectId, @name, @startUrl) ->
    @authToken = window.autoTestAuthToken
    @apiUrl = window.autoTestApiUrl
    @sessionStorage = window.sessionStorage
    @id = ""
    @autoTestSteps = []

  save: ->
    autoTestScenario = ""
    if @id == ""
      that = this
      $.ajax(@apiUrl + '/api/v1/projects/' + @projectId + '/scenarios',
        type: 'POST',
        dataType: "json",
        data: {scenario: {name: this.name, start_url: this.startUrl}},
        async: false,
        beforeSend: (xhr, settings) ->
          xhr.setRequestHeader('Authorization', "Token token=\"#{that.authToken}\"")
        success: (data, textStatus, jqXHR) ->
          autoTestScenario = new AutoTestScenario data.scenario.project_id, data.scenario.name, @startUrl
          autoTestScenario.id = data.scenario.id
        error:  (jqXHR, textStatus, errorThrown) ->
          console.log("error thrown")
      )
    else
      autoTestScenario = this
    return  autoTestScenario

  steps: ->
    autoTestSteps = AutoTestStep.findAll(@id)
    return autoTestSteps

  addStep: (type, locator, text) ->
    console.log("text is #{text}")
    autoTestStep = AutoTestStep.create this.id, type, locator, text
    console.log(autoTestStep)
    @autoTestSteps.push(autoTestStep)
    return true

  # Attributes is an object
  @create: (projectId, name, startUrl) ->
    scenario = new AutoTestScenario projectId, name, startUrl
    autoTestScenario = scenario.save()
    return autoTestScenario

  @find: (projectId, id) ->
    apiUrl = window.autoTestApiUrl
    authToken = window.autoTestAuthToken
    autoTestScenario = ""
    $.ajax(apiUrl + "/api/v1/projects/#{projectId}/scenarios/#{id}",
        type: 'GET',
        dataType: 'json',
        async: false,
        beforeSend: (xhr, settings) ->
          xhr.setRequestHeader('Authorization', "Token token=\"#{authToken}\"")        
        success: (data) ->
          console.log(data)
          autoTestScenario = new AutoTestScenario(data.scenario.project_id, data.scenario.name, data.scenario.start_url)
          autoTestScenario.id = data.scenario.id
          autoTestScenario.autoTestSteps = autoTestScenario.steps()
    )
    return autoTestScenario
