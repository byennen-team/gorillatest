class Scenario

  attr_accessor :driver

  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Slug

  field :name, type: String
  field :window_x, type: Integer
  field :window_y, type: Integer
  field :start_url, type: String

  slug :name

  #embedded_in :feature, inverse_of: :scenarios
  belongs_to :feature

  embeds_many :steps

  has_many :test_runs, class_name: 'ScenarioTestRun'

  validates :name, presence: true, uniqueness: {conditions: -> { where(deleted_at: nil)}, scope: :feature}
  validates :window_x, :window_y, presence: true
end
