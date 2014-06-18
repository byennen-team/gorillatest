class BetaInvitation
  include Mongoid::Document
  field :first_name, type: String
  field :last_name, type: String
  field :company, type: String
  field :email, type: String

  validates :first_name, :last_name, :email, presence: true

  validates_format_of :email, :with => Devise::email_regexp

  after_create :add_user_to_email_list

  private

  def add_user_to_email_list
    return unless Rails.env.production?
    Gibbon::API.new.lists.subscribe({
      :id => ENV['MAILCHIMP_LIST_ID'],
      :email => {:email => self.email},
      :double_optin => false,
      :update_existing => true,
      :send_welcome => false
    })
    Rails.logger.info("Subscribed #{self.email} to MailChimp")
  end
end
