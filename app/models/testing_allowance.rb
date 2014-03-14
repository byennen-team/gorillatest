class TestingAllowance

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :seconds_used, type: Integer, default: 0
  field :start_at, type: DateTime, default: Time.now.beginning_of_month

  belongs_to :timeable, polymorphic: true

  def self.current_month
    current_allowance = where(start_at: Time.now.beginning_of_month).first
    unless current_allowance
      return create(timeable_id: scoped.selector["timeable_id"], timeable_type: scoped.selector["timeable_type"])
    end
    return current_allowance
  end

  def minutes_used
    (seconds_used / 60.0).floor
  end

end