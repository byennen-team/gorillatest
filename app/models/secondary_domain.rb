class SecondaryDomain

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :project

  field :domain

end