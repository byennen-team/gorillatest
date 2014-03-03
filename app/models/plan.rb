class Plan
  UNLIMITED_MINUTES = 60*60*1000

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :price, type: Money
  field :seconds_available, type: Integer

  validates :name, :price, :seconds_available, presence: true

  has_many :users

  def unlimited?
    seconds_available == UNLIMITED_MINUTES
  end

  def minutes_available
    (seconds_available / 60.0).floor
  end
end
