# Describes the user trait of being a plan customer, including responsibilities of plan setting and payments
module PlanCustomer
  def self.included(some_class)
    some_class.class_eval do
      field :stripe_customer_token, type: String
      field :stripe_subscription_token, type: String

      before_create :assign_default_plan
      after_create :subscribe_to_plan

      belongs_to :plan
      has_many :credit_cards do
        def default
          where(default: true).first
        end
        def non_default
          where(default: false).to_a
        end
      end

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

  def subscribe_to(new_plan)
    old_plan_id = self.plan ? self.plan.id : nil
    customer = create_or_retrieve_stripe_customer
    unless stripe_subscription_token.nil?
      subscription =  customer.subscriptions.retrieve(stripe_subscription_token)
      subscription.plan = new_plan.stripe_id
      if subscription.save
        update_attribute(:plan_id, new_plan.id)
      end
    else
      subscription = customer.subscriptions.create(plan: new_plan.stripe_id)
    end
    update_attribute(:stripe_subscription_token, subscription.id)
    unless old_plan_id.nil?
      UserMailer.plan_change(self.id.to_s, old_plan_id.to_s, self.plan_id.to_s).deliver
    end
  end

  def stripe_subscription
    customer = create_or_retrieve_stripe_customer
    customer.subscriptions.first
  end

  def can_create_project?
    self.owned_projects.count < self.plan.num_projects
  end

  def can_downgrade?(plan)
    return false if self.owned_projects.length > plan.num_projects
    # Project members
    self.owned_projects.each do |project|
     return false if project.users.length > plan.num_users
    end
    # Minutes used
    return false if testing_allowances.current_month.seconds_used >= plan.seconds_available
    return true
  end

  private

  def assign_default_plan
    self.plan = Plan.where(name:"Free").first
    Rails.logger.debug("plan is #{self.plan.inspect}")
    #self.save
  end

  # Make sure they have a stripe customer and free plan
  def subscribe_to_plan
    subscribe_to(plan)
  end

end
