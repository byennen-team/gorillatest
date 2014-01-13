class StepSerializer < ActiveModel::Serializer

  attributes :id, :scenario_id, :event_type, :locator_type, :locator_value, :text

  def id
  	object.id.to_s
  end

  def scenario_id
    object.scenario.id.to_s
  end
end