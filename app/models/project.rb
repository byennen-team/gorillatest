class Project

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :url, type: String
  field :status, type: String

  belongs_to :company

  has_many :features
  
  # Figure out how to do the project /user relationships
  # user has_and_belongs_to_many projects / teams. - jkr

end
