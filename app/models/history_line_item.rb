class HistoryLineItem
  include Mongoid::Document

  field :text,   type: String
  field :status, type: String
  field :parent, type: Integer, default: 0

  embedded_in :test_history

end
