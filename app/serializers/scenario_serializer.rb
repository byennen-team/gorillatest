class ScenarioSerializer < ActiveModel::Serializer
  attributes :id, :project_id, :name

  def id
  	object.id.to_s
  end

  def project_id
    object.project_id.to_s
  end

end
