class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, type: String
  field :url, type: String
  field :read, type: Boolean

  belongs_to :user



end
