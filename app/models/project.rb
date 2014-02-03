class Project

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :url, type: String
  field :status, type: String

  belongs_to :company, inverse_of: :projects

  has_many :features

  validates :name, presence: true, uniqueness: {scope: :company}

  before_create :add_auth_key

  # Figure out how to do the project /user relationships
  # user has_and_belongs_to_many projects / teams. - jkr

  private

  def add_auth_key
    self.api_key = SecureRandom.hex
  end
end
