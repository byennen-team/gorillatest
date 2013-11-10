class Step
  include Mongoid::Document
  include Mongoid::Timestamp

  field :field_id, type: String
  field :field_value, type: String

  # This should be things like click, enter text, redirect_to, etc.
  field :action, type: String

  embedded_in :scenario

end
