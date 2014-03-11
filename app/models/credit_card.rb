class CreditCard
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :stripe_token

  field :stripe_id, type: String
  field :name, type: String
  field :last4, type: String
  field :cc_type, type: String
  field :exp_month, type: String
  field :exp_year, type: String

  belongs_to :user

  validates :stripe_id, :name, :last4, :cc_type, presence: true

  before_validation :fetch_stripe_data

  private

  def fetch_stripe_data
    stripe_customer = user.create_or_retrieve_stripe_customer
    Rails.logger.debug("stripe customer is #{stripe_customer.inspect}")
    # user.subscribe_to(Plan.order(sort_option: :price).first.stripe_id)
    begin
      stripe_card = stripe_customer.cards.create({card: self.stripe_token})
      self.stripe_id = stripe_card.id
      self.last4 = stripe_card.last4
      self.cc_type = stripe_card.type
      self.name = stripe_card.name
      self.exp_month = stripe_card.exp_month
      self.exp_year = stripe_card.exp_year
    rescue Exception => e
      Rails.logger.error(e.inspect)
      # errors.base(e.message)
    end
   end

end
