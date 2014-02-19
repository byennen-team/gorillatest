require 'digest/md5'

class User

  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable,
         :omniauthable, omniauth_providers: [:google_oauth2]

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

  field :provider, type: String
  field :uid, type: String

  index( {invitation_token: 1}, {:background => true} )
  index( {invitation_by_id: 1}, {:background => true} )

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

  validates :first_name, :last_name, :company_name, presence: { message: "can't be blank"}

  #before_save :strip_phone
  after_create :send_welcome_email

  def send_invitation(inviter_id)
    InvitationMailer.send_invitation(self.id, inviter_id).deliver
  end

  def send_project_invitation(inviter_id, project_id)
    InvitationMailer.send_project_invitation(self.id, inviter_id, project_id).deliver
  end

  def gravatar_hash
    email_address = self.email.downcase
    hash = Digest::MD5.hexdigest(email_address)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def projects
    Project.in(id: project_users.map(&:project_id))
  end

  def owned_projects
    projects.where(rights: 'owner')
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
      user.provider = auth.provider
      user.uid = auth.uid
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.password_confirmation = Devise.friendly_token[0,20]
    end
    return user
  end

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver
  end

end
