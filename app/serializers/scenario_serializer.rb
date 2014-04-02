class ScenarioSerializer < ActiveModel::Serializer
  attributes :id, :project_id, :name, :dashboard_url

  def id
  	object.id.to_s
  end

  def project_id
    object.project_id.to_s
  end

  def dashboard_url
    url_for(project_test_path(object.project, object.slug))
  end

end
