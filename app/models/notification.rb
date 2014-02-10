class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, type: String
  field :subdomain, type: String
  field :service, type: String
  field :room_name, type: String

  embedded_in :project

  def speak(message)
    case service
    when "campfire"
      campfire = Tinder::Campfire.new self.subdomain, token: self.token
      room =campfire.find_room_by_name(self.room_name)
      room.speak(message)
    end
  end
end
