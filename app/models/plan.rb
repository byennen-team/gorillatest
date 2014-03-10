class Plan
  UNLIMITED_MINUTES = 60*60*1000

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :price, type: Money
  field :seconds_available, type: Integer
  field :num_projects, type: Integer
  field :num_users, type: Integer
  field :concurrent_browsers, type: Integer
  field :stripe_id, type: String

  validates :name, :price, :seconds_available, presence: true

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
end
