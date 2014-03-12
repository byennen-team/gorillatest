# Describes the user trait of being a plan customer, including responsibilities of plan setting and payments
module PlanCustomer
  def self.included(some_class)
    some_class.class_eval do
      field :stripe_customer_token, type: String
      field :stripe_subscription_token, type: String

      after_create :assign_default_plan
      after_create :subscribe_to_plan

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

  def subscribe_to(plan)
    customer = create_or_retrieve_stripe_customer
    if !stripe_subscription_token.nil?
      subscription =  customer.subscriptions.retrieve(stripe_subscription_token)
      subscription.plan = plan.stripe_id
      self.plan_id = plan.id
      subscription.save && self.save
    else
      subscription = customer.subscriptions.create(plan: plan.stripe_id)
    end
    update_attribute(:stripe_subscription_token, subscription.id)
  end

  def stripe_subscription
    customer = create_or_retrieve_stripe_customer
    customer.subscriptions.first
  end

  #def upgrade(plan)
  #  if qualifies?(plan)
  #    customer = create_or_retrieve_stripe_customer
  #    subscription = customer.subscriptions.all.first
  #    subscription.plan = plan
  #    subscription.save
  #    self.plan = plan
  #    save!
  #  end
  #end

  private

  def assign_default_plan
    self.plan = Plan.where(name:"Free").first
    self.save
  end

  # Make sure they have a stripe customer and free plan
  def subscribe_to_plan
    subscribe_to(plan)
  end

end