class Feature
  include Mongoid::Document
  include Mongoid::Timestamp

  field :name, type: String

  belongs_to :project
  belongs_to :user

  embeds_many :scenarios

end
