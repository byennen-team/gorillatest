require 'nokogiri'

class Project

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Slug

  field :name, type: String
  field :url, type: String
  field :status, type: String
  field :api_key, type: String
  field :script_verified, type: Boolean, default: false
  field :email_notification, type: String, default: "success"
  field :basic_auth_username, type: String
  field :basic_auth_password, type: String
  field :demo_project, type: Boolean, default: false

  slug :name

  belongs_to :user

  alias :creator :user

  has_many :scenarios
  has_many :project_users, dependent: :destroy
  has_many :test_runs, class_name: 'ProjectTestRun', dependent: :destroy

  embeds_many :secondary_domains, class_name: 'SecondaryDomain'

  validates :name, presence: true, uniqueness: {scope: :user}

  validates :url, presence: true, url: true

  before_create :add_auth_key

  embeds_many :notifications

  # Figure out how to do the project /user relationships
  # user has_and_belongs_to_many projects / teams. - jkr


  def post_notifications(message)
    notifications.each do |notification|
      notification.speak(message)
    end
  end

  def base_url(scheme)
    base_url = "#{scheme}://#{host}"
    if [80,443].include?(port)
      return base_url
    else
      return "#{base_url}:#{port}"
    end
  end

  def has_invitations_left?
    creator.plan.num_users > users.count
  end

  def num_invitations_remaining
    creator.plan.num_users - users.count
  end

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

  def all_test_runs
    (test_runs + scenarios.map{|s| s.test_runs}).flatten.sort_by(&:created_at).reverse
  end

  def num_passed_tests
    all_test_runs.select{|t| t.status == "pass"}.count
  end

  def num_failed_tests
    all_test_runs.select{|t| t.status == "fail"}.count
  end

  def num_running_tests
    all_test_runs.select{|t| t.status != "running"}.count
  end

  private

  def port
    URI.parse(url).port
  end

  # def scheme
  #   URI.parse(url).scheme
  # end

  def host
    URI.parse(url).host
  end

  # Add specs for this.
  def search_for_script
    # Can't have a hard coded script source:
    autotest_script_source = "#{ENV['API_URL']}/assets/recordv2.js"
    # Need to add a rescue, open will throw an exception if it can't open the URL

    begin
      if !self.basic_auth_username.blank?
        auth = {username: self.basic_auth_username, password: self.basic_auth_password}
        response = HTTParty.get(url, basic_auth: auth)
      else
        response = HTTParty.get(url)
      end

      document = Nokogiri::HTML(response.body)
      document.search("script").detect do |script|
        if script.attributes["src"] && script.attributes["src"].value.include?(autotest_script_source)
          return project_script_valid?(script)
        end
      end
    rescue Exception => e
      Rails.logger.debug("error is #{e.inspect}")
      return false
    end
  end

  def project_script_valid?(script)
    attrs = []
    attrs << script.attributes['data-api-key'].value
    attrs << script.attributes['data-project-id'].value
    return attrs.sort == [api_key, id.to_s].sort
  end

  def add_auth_key
    self.api_key = SecureRandom.hex
  end

end
