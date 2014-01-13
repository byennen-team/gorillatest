class Step
  include Mongoid::Document
  include Mongoid::Timestamps

 field :event_type, type: String
 field :locator_type, type: String
 field :locator_value, type: String
 field :text, type: String

  embedded_in :scenario

end
