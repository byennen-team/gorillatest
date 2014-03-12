require 'spec_helper'

describe PlanCustomer do
  let!(:plan) { create(:plan, stripe_id: "free") }
  let!(:stripe_plan) { Stripe::Plan.create(amount: 0,
                                           interval: 'month',
                                           name: 'Free',
                                           currency: 'usd',
                                           id: 'free')}
  let(:user) { create(:user) }

  describe 'generates subscription when setting payment'

  describe 'upgrade plan' do
    context "qualifies for upgrade" do
      it 'generates card charge for user and generates subscription' do

      end
      it 'changes plan on plan customer'
      it 'changes plan on stripe customer subscription'
    end
    context "does not qualify for upgrade" do
      it 'changes plan on plan customer' do

      end
      it 'changes plan on stripe customer subscription'
    end
  end

  describe 'creating stripe customer' do

    let!(:plan) { create(:plan, stripe_id: "free") }

    context 'stripe customer should be created w/ user' do

      it "should have a stripe customer token" do
         expect(user.stripe_customer_token).to_not be_nil
      end

      it "should have a stipre_subscription_token" do
        expect(user.stripe_subscription_token).to_not be_nil
      end

      it "should have be subscribed to a free plan" do
        expect(user.plan).to eq(plan)
      end

      it "should have a stripe subscription that is for a free plan" do
        expect(user.stripe_subscription.id).to eq(user.stripe_subscription_token)
      end

    end

  end

end
