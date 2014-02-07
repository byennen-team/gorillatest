require 'uri'
require 'open-uri'

class Project

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
  validates :url, url: true

  before_create :add_auth_key

  # Figure out how to do the project /user relationships
  # user has_and_belongs_to_many projects / teams. - jkr

  def users
    users = User.in(id: project_users.map(&:user_id)).all
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


  # Add specs for this.
  def search_for_script
    # Can't have a hard coded script source:
    autotest_script_source = "autotest.dev/assets/recordv2.js"
    # Need to add a rescue, open will throw an exception if it can't open the URL
    begin
      document = Nokogiri::HTML(open(self.url, "Accept" => "text/html"))
      document.search("script").detect do |script|
        script.attributes["src"].value.include?(autotest_script_source) if script.attributes["src"]
      end
    rescue Exception => e
      Rails.logger.debug("error is #{e.inspect}")
      return false
    end
  end

  def add_auth_key
    self.api_key = SecureRandom.hex
  end

end
