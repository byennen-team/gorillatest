class Feature
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name, type: String

  slug :name

  # embedded_in :test_run
  embeds_many :scenarios

  belongs_to :project
  belongs_to :user

  has_many :scenarios
  has_many :test_runs, class_name: 'FeatureTestRun'

  validates :name, presence: true, uniqueness: {scope: :project}

end
