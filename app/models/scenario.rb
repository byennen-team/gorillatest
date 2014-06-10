class Scenario

  attr_accessor :driver

  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Slug

  field :name, type: String
  field :window_x, type: Integer
  field :window_y, type: Integer
  field :start_url, type: String

  # for demoing playback with fake results
  field :demo, type: Boolean
  field :fail_browsers, type: String
  field :fail_step_num, type: Integer

  slug :name

  belongs_to :project

  embeds_many :steps

  has_many :test_runs, class_name: 'ScenarioTestRun'

  validates :name, presence: true, uniqueness: {conditions: -> { where(deleted_at: nil)}, scope: :project}
  validates :window_x, :window_y, presence: true

  def current_status
    if test_runs.present?
      test_runs.last.status
    else
      return "unran"
    end
  end

end
