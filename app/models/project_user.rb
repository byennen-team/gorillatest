class ProjectUser

  include Mongoid::Document
  include Mongoid::Paranoia

  field :rights, type: String

  belongs_to :user
  belongs_to :project

end