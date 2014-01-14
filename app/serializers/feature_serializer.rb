class FeatureSerializer < ActiveModel::Serializer

  attributes :id, :name, :project_id

  def id
    object.id.to_s
  end

  def project_id
    object.project_id.to_s
  end

end