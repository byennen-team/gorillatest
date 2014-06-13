class ScenarioSerializer < ActiveModel::Serializer
  attributes :id, :project_id, :name, :dashboard_url, :projectName

  def id
  	object.id.to_s
  end

  def project_id
    object.project_id.to_s
  end

  def dashboard_url
    project_url(object.project)
  end

  def projectName
    object.project.name
  end

end
