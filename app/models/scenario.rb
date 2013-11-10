class Scenario

 include Mongoid::Document

 field :name, type: String

 embedded_in :feature

end
