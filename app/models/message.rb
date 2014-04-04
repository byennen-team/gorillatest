class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, type: String
  field :url, type: String
  field :read, type: Boolean, default: false

  belongs_to :user

  after_create :send_to_pusher

  def send_to_pusher
    Pusher.trigger(["messages_#{user_id.to_s}"], 'new_message', MessageSerializer.new(self).as_json(root: false))
  end

end
