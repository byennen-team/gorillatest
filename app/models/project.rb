class Project

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :url, type: String
  field :status, type: String
  field :api_key, type: String

  belongs_to :user

  has_many :features
  has_many :project_users

  validates :name, presence: true

  before_create :add_auth_key

  # Figure out how to do the project /user relationships
  # user has_and_belongs_to_many projects / teams. - jkr

  def users
    users = User.in(id: project_users.map(&:user_id)).all
    Rails.logger.debug("Users are ")
    Rails.logger.debug("\n\n\n\n\n\n\n\n\n")
    Rails.logger.debug(users.inspect)
    return users.to_a
  end

  def owners
    pu_owners = project_users.select { |pu| pu.user if pu.rights == 'owner' }
    pu_owners.map(&:user)
  end

  def owner?(user)
    owners.include?(user)
  end

  private

  def add_auth_key
    self.api_key = SecureRandom.hex
  end

end
