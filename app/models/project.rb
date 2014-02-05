class Project

  require 'open-uri'

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :url, type: String
  field :status, type: String
  field :api_key, type: String
  field :script_verified, type: Boolean, default: false

  belongs_to :user

  has_many :features
  has_many :project_users

  validates :name, :url, presence: true

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

  def script_present?
    search_for_script
  end

  private

  def search_for_script
    autotest_script_source = "autotest-staging.herokuapp.com/assets/recordv2.js"
    document = Nokogiri::HTML(open(self.url))
    document.search("script").detect do |script|
      script.attributes["src"].value.include?(autotest_script_source) if script.attributes["src"]
    end
  end

  def add_auth_key
    self.api_key = SecureRandom.hex
  end

end
