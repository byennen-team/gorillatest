class ProjectUser

  include Mongoid::Document

  field :rights, type: String

  belongs_to :user
  belongs_to :project

end