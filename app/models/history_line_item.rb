class HistoryLineItem
  include Mongoid::Document

  field :text,   type: String
  field :status, type: String
  field :parent, type: String, default: 0

  belongs_to :test_history
  belongs_to :parent, class_name: 'HistoryLineItem'
  has_many :children, class_name: 'HistoryLineItem'
  belongs_to :testable, polymorphic: true



end
