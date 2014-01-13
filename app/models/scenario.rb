class Scenario

 include Mongoid::Document

 field :name, type: String
 
 field :event_type, type: String
 field :locator_type, type: String
 field :locator_value, type: String
 field :text, type: String

 embedded_in :feature

 embeds_many :steps

end
