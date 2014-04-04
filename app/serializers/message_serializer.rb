class MessageSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :message, :url, :read

  def id
    object.id.to_s
  end

  def user_id
    object.user_id.to_s
  end

end
