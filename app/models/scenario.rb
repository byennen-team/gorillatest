class Scenario

  attr_accessor :driver

  include Mongoid::Document
  include Mongoid::Paranoia

 field :name, type: String

 field :event_type, type: String
 field :locator_type, type: String
 field :locator_value, type: String
 field :text, type: String
 field :window_x, type: Integer
 field :window_y, type: Integer
 field :start_url, type: String

 #embedded_in :feature
 belongs_to :feature

 embeds_many :steps

 has_many :test_runs

 validates :name, presence: true, uniqueness: {scope: :feature}

end
