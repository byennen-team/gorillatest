class Feature
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  belongs_to :project
  belongs_to :user

  embeds_many :scenarios

end
