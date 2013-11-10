class Feature
  include Mongoid::Document
  include Mongoid::Timestamp

  field :name, type: String

  embeds_many :scenarios

end
