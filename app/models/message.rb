class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, type: String
  field :url, type: String
  field :read, type: Boolean, default: false

  belongs_to :user



end
