class @AutoTestScenario
  constructor: (@authToken, @projectId, @name, @startUrl) ->
    @sessionStorage = window.sessionStorage
    @id = ""
    @autoTestSteps = []

  save: ->
    autoTestScenario = ""
    if @id == ""
      that = this
      $.ajax('http://autotest.dev/api/v1/projects/' + @projectId + '/scenarios',
        type: 'POST',
        dataType: "json",
        data: {scenario: {name: this.name, start_url: this.startUrl}},
        async: false,
        beforeSend: (xhr, settings) ->
          xhr.setRequestHeader('Authorization', "Token token=\"#{that.authToken}\"")
        success: (data, textStatus, jqXHR) ->
          autoTestScenario = new AutoTestScenario that.authToken, data.scenario.project_id, data.scenario.name, @startUrl
          autoTestScenario.id = data.scenario.id
        error:  (jqXHR, textStatus, errorThrown) ->
          console.log("error thrown")
      )
    else
      autoTestScenario = this
    return  autoTestScenario

  steps: ->
    autoTestSteps = AutoTestStep.findAll(@authToken, @id)
    return autoTestSteps

  addStep: (type, locator, text) ->
    autoTestStep = AutoTestStep.create @authToken, this.id, type, locator, text
    @autoTestSteps.push(autoTestStep)
    return true

  # Attributes is an object
  @create: (authToken, projectId, name, startUrl) ->
    console.log("Auth token is #{authToken}")
    scenario = new AutoTestScenario authToken, projectId, name, startUrl
    autoTestScenario = scenario.save()
    return autoTestScenario

  @find: (authToken, projectId, id) ->
    autoTestScenario = ""
    $.ajax("http://autotest.dev/api/v1/projects/#{projectId}/scenarios/#{id}",
        type: 'GET',
        dataType: 'json',
        async: false,
        beforeSend: (xhr, settings) ->
          xhr.setRequestHeader('Authorization', "Token token=\"#{authToken}\"")        
        success: (data) ->
          console.log(data)
          autoTestScenario = new AutoTestScenario(authToken, data.scenario.project_id, data.scenario.name, data.scenario.start_url)
          autoTestScenario.id = data.scenario.id
          autoTestScenario.autoTestSteps = autoTestScenario.steps()
    )
    return autoTestScenario
