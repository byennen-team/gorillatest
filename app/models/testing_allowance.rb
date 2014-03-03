class TestingAllowance

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :seconds_used, type: Integer
  field :start_at, type: DateTime

  belongs_to :timeable, polymorphic: true

  #scope :current_month, where(start_at: "2014-02-01 00:00:00")

  def minutes_used
    (seconds_used / 60)
  end

  def self.current_month
    where(start_at: Time.now.beginning_of_month).first
  end

end
