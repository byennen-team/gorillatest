class @AutoTestFeature

	constructor: (@projectId, @name) ->
		@authToken = window.autoTestAuthToken
		@apiUrl = window.autoTestApiUrl
		@id = ""


	@findAll: (@projectId) ->
    apiUrl = window.autoTestApiUrl
    authToken = window.autoTestAuthToken
    console.log("authTOken in find all is #{authToken}")
    features = new Array
    $.ajax("#{apiUrl}/api/v1/projects/#{@projectId}/features",
      type: 'GET',
      dataType: 'json',
      async: false,
      beforeSend: (xhr, settings) ->
        console.log("setting auth token")
        xhr.setRequestHeader('Authorization', "Token token=\"#{authToken}\"")
      success: (data) ->
        $.each(data.features, (i, data) ->
          autoTestFeature = new AutoTestFeature(data.project_id, data.name)
          autoTestFeature.id = data.id
          features.push(autoTestFeature)
        )
    )
    return features

  @find: (projectId, featureId) ->
    apiUrl = window.autoTestApiUrl
    authToken = window.autoTestAuthToken
    autoTestFeature = {}
    $.ajax("#{apiUrl}/api/v1/projects/#{projectId}/features/#{featureId}",
      type: 'GET',
      dataType: 'json',
      async: false,
      beforeSend: (xhr, settings) ->
        xhr.setRequestHeader('Authorization', "Token token=\"#{authToken}\"")
      success: (data) ->
        autoTestFeature = new AutoTestFeature(data.feature.project_id, data.feature.name)
        autoTestFeature.id = data.feature.id
    )
    return autoTestFeature
