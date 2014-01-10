class @AutoTestScenario
  constructor: (@projectId, @name, @startUrl) ->
    @sessionStorage = window.sessionStorage
    @id = ""
    if @sessionStorage.getItem("steps") != ""
      @steps = []
    else
      @steps = []

  save: ->
    autoTestScenario = ""
    if @id == ""
      $.ajax('http://autotest.dev/api/projects/' + @projectId + '/scenarios',
        type: 'POST',
        dataType: "json",
        data: {scenario: {name: this.name, start_url: this.startUrl}},
        async: false,
        success: (data, textStatus, jqXHR) ->
          autoTestScenario = new AutoTestScenario data.project_id, data.name, @startUrl
          autoTestScenario.id = data.id
          return autoTestScenario
        error:  (jqXHR, textStatus, errorThrown) ->
          console.log("error thrown")
      )
    else
      autoTestScenario = this
    return  autoTestScenario

  addStep: (type, locator, text) ->
    autoTestStep = new AutoTestStep this.id, type, locator, text
    autoTestStep.save
    @steps.push(autoTestStep)
    return true

  # Attributes is an object
  @create: (projectId, name, startUrl) ->
    scenario = new AutoTestScenario projectId, name, startUrl
    autoTestScenario = scenario.save()
    return autoTestScenario

  @find: (projectId, id) ->
    autoTestScenario = ""
    $.ajax("http://autotest.dev/api/projects/#{projectId}/scenarios/#{id}",
        type: 'GET',
        dataType: 'json',
        async: false,
        success: (data) ->
          autoTestScenario = new AutoTestScenario(projectId, data.name, data.start_url)
          autoTestScenario.id = data.id
    )
    return autoTestScenario
