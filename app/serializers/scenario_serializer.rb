class ScenarioSerializer < ActiveModel::Serializer
  attributes :id, :feature_id, :name, :project_id

  def id
  	object.id.to_s
  end

  def feature_id
    object.feature.id.to_s
  end

  def project_id
    object.feature.project_id.to_s
  end

end
