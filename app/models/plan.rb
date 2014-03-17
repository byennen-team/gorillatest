class Plan
  UNLIMITED_MINUTES = 60*60*1000

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :price, type:   Money
  field :seconds_available, type: Integer
  field :num_projects, type: Integer
  field :num_users, type: Integer
  field :concurrent_browsers, type: Integer
  field :stripe_id, type: String
  field :developer_mode, type: Boolean
  field :import_selenium_scripts, type: Boolean
  field :test_scheduling, type: Boolean
  field :deploy_process, type: Boolean
  field :popular, type: Boolean
  field :plan_style, type: String


  #Developer Mode
  #Import Selenium Scripts
  #Test Scheduling
  #Integrate into Deploy Process

  validates :name, :price, :seconds_available, presence: true
  validates :stripe_id, uniqueness: true

  has_many :users

  def unlimited?
    seconds_available == UNLIMITED_MINUTES
  end

  def free?
    price == 0
  end

  def minutes_available
    (seconds_available / 60.0).floor
  end

  def hours_available
    minutes_available / 60
  end

end
