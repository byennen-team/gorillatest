class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, type: String
  field :subdomain, type: String
  field :service, type: String
  field :room_name, type: String

  embedded_in :project
end
