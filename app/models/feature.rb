class Feature
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  # embedded_in :test_run
  embeds_many :scenarios

  belongs_to :project
  belongs_to :user

  has_many :scenarios
  has_many :feature_test_runs

  validates :name, presence: true, uniqueness: {scope: :project}

end
