# Describes the user trait of being a plan customer, including responsibilities of plan setting and payments
module PlanCustomer
  def self.included(some_class)
    some_class.class_eval do
      field :stripe_customer_token, type: String

      after_create :assign_default_plan

      belongs_to :plan
      has_one :credit_card

      delegate :seconds_available, to: :plan
      delegate :minutes_available, to: :plan
    end
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


end