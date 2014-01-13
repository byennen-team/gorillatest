class Company

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :api_key, type: String

  # This is the user that created the project.  Need to work
  # out the relationships.  is it a company has many users?
  belongs_to :user, inverse_of: :user

  has_many :users, inverse_of: :company
  has_many :projects, inverse_of: :company, autosave: true

  before_create :add_auth_key

  private

    def add_auth_key
    	self.api_key = SecureRandom.hex
    end

end
