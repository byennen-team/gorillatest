require 'digest/md5'

class User

  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable

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

  has_many :projects

  validates :first_name, :last_name, :company_name, presence: { message: "can't be blank"}

  #before_save :strip_phone
  after_create :send_welcome_email

  def self.send_invitation(invited_user)
    UserMailer.send_invitation_email(invited_user).deliver
  end

  def gravatar_hash
    email_address = self.email.downcase
    hash = Digest::MD5.hexdigest(email_address)
  end

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver
  end

end
