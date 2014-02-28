module TestDuration
  extend ActiveSupport::Concern

  included do
    field :queued_at, type: DateTime
    field :ran_at, type: DateTime
    field :completed_at, type: DateTime
  end

  def duration
    if ran_at.nil?
      return 0
    elsif completed_at.nil?
      return Time.now.to_i - ran_at.to_i
    else
      return completed_at.to_i - ran_at.to_i
    end
  end

end
