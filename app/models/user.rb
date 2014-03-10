require 'digest/md5'

class User
  include Mongoid::Document
  rolify
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable,
         :omniauthable, :confirmable, :registerable, omniauth_providers: [:google_oauth2, :github]

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Invitable
  field :invitation_token, type: String
  field :invitation_created_at, type: Time
  field :invitation_sent_at, type: Time
  field :invitation_accepted_at, type: Time
  field :invitation_limit, type: Integer

  field :confirmation_token, type: String
  field :confirmed_at, type: Time
  field :confirmation_sent_at, type: Time

  field :provider, type: String
  field :uid, type: String

  field :stripe_customer_token, type: String

  index( {invitation_token: 1}, {background: true} )
  index( {invitation_by_id: 1}, {background: true} )
  # index( {confirmation_token: 1}, {background: true} ) # TODO: errors out when running rake db:mongoid:key => "value", create_indexes


  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Non-Devise
  field :company_name, type: String
  field :phone, type: String
  field :location, type: String
  field :first_name, type: String
  field :last_name, type: String

  # has_many :projects
  has_many :project_users
  has_many :coupon_users

  has_many :testing_allowances, as: :timeable

  validates :first_name, :last_name, :email, :password, :password_confirmation, presence: { message: "can't be blank"}
  has_one :credit_card

  belongs_to :plan

  delegate :seconds_available, to: :plan
  delegate :minutes_available, to: :plan

  #before_save :strip_phone
  # after_create :send_welcome_email
  before_validation :set_random_password
  after_create :assign_default_plan

  def send_invitation(inviter_id)
    InvitationMailer.send_invitation(self.id, inviter_id).deliver
  end

  def send_project_invitation(inviter_id, project_id)
    InvitationMailer.send_project_invitation(self.id, inviter_id, project_id).deliver
  end


  def gravatar_url(size)
    "https://www.gravatar.com/avatar/#{gravatar_hash}?s=#{size}"
  end

  def name
    "#{first_name} #{last_name}"
  end

  def coupons
    Coupon.in(id: coupon_users.map(&:coupon_id))
  end

  def projects
    Project.in(id: project_users.map(&:project_id))
  end

  def owned_projects
    pu_owners = project_users.select { |pu| pu.user if pu.rights == 'owner' }
    pu_owners.map(&:project)
  end

  def self.from_omniauth(auth, invitation_token = nil)
    user = nil
    if user = User.where(email: auth.info.email).first
      user.provider = auth.provider
      user.uid = auth.uid
    else
      if invitation_token
        user = User.find_by(invitation_token: invitation_token)
      else
        user = where(auth.slice(:provider, :uid)).first_or_create
      end
      user.assign_user_info_from_oauth(auth)
    end
    return user
  end

  def assign_user_info_from_oauth(auth)
    self.attributes = {email: auth.info.email, provider: auth.provider, uid: auth.uid}
    if auth.info.first_name
      self.first_name = auth.info.first_name
      self.last_name = auth.info.last_name
    else
      self.first_name = auth.info.name.split(' ').first
      self.last_name = auth.info.name.split(' ').last
    end
  end

  def confirm!
    self.send_welcome_email
    super
  end

  def send_welcome_email
    if self.invitation_token.blank?
      UserMailer.welcome_email(self).deliver
    end
  end

  def has_minutes_available?
    current_allowance.minutes_used < minutes_available
  end

  def available_minutes
    minutes_available - used_minutes
  end

  def used_minutes
    current_allowance.minutes_used
  end

  def current_allowance
    testing_allowances.current_month
  end

  def create_or_retrieve_stripe_customer
    unless stripe_customer_token.nil?
      customer = Stripe::Customer.retrieve(stripe_customer_token)
    else
      customer = Stripe::Customer.create(description: "#{first_name} #{last_name}", email: email)
      update_attribute(:stripe_customer_token, customer.id)
    end
    customer
  end

  private

  def assign_default_plan
    self.plan = Plan.where(name:"Free").first
    self.save
  end

  def gravatar_hash
    email_address = self.email.downcase
    hash = Digest::MD5.hexdigest(email_address)
  end

  def set_random_password
    if !self.company_name.blank? && !self.uid.blank? && !self.provider.blank? && self.encrypted_password.blank?
      password =  Devise.friendly_token[0,20]
      self.password = password
      self.password_confirmation = password
    end
  end
end
