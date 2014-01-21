class Feature
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  #embeds_many :scenarios

  belongs_to :project
  belongs_to :user

  has_many :scenarios

  validate :name, presence: true, uniqueness: {scope: :project}

end
