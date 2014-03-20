class DefaultCreditCardUndeletable < Exception; end

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
  field :default, type: Boolean

  belongs_to :user

  validates :stripe_id, :name, :last4, :cc_type, presence: true


  before_validation :update_data_from_stripe, on: :create
  after_create :set_default

  before_destroy :ensure_card_not_default, prepend: true
  before_destroy :remove_from_stripe

   def stripe_card
    stripe_customer = user.create_or_retrieve_stripe_customer
    credit_card = stripe_customer.cards.retrieve(stripe_id)
  end

  def set_default
    user.credit_cards.each { |cc| cc.update_attribute(:default, false) }
    self.default = true
    customer = user.create_or_retrieve_stripe_customer
    customer.default_card = self.stripe_id
    customer.save
    self.save!
  end

  private

  def update_data_from_stripe
    stripe_customer = user.create_or_retrieve_stripe_customer
    card = stripe_customer.cards.create({card: self.stripe_token})
    self.stripe_id = card.id
    self.last4 = card.last4
    self.cc_type = card.type
    self.name = card.name
    self.exp_month = card.exp_month
    self.exp_year = card.exp_year
    self.stripe_token = nil
   end

   def ensure_card_not_default
     if self.default?
      raise DefaultCreditCardUndeletable
    end
  end

  def remove_from_stripe
    customer = user.create_or_retrieve_stripe_customer
    customer.cards.retrieve(self.stripe_id).delete()
  end

end
