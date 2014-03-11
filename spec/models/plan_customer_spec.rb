require 'spec_helper'

describe PlanCustomer do
  let!(:plan) { create(:plan, stripe_id: "free") }
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
    let(:stripe_customer_token) {"12344555"}
    let(:customer) {stub('customer', {description: "#{user.first_name} #{user.last_name}",
                                      email: user.email,
                                      id: stripe_customer_token})}
    context 'without being a current stripe customer' do
      before do
        Stripe::Customer.expects(:create).with(email: user.email, description: "#{user.first_name} #{user.last_name}").returns(customer)
      end

      it "should create and return stripe user" do
        stripe_customer = user.create_or_retrieve_stripe_customer
        stripe_customer.should == customer
        user.reload.stripe_customer_token.should_not be_nil
      end

    end

    context 'with being a current stripe customer' do
      before do
        user.update_attribute(:stripe_customer_token, stripe_customer_token)
        Stripe::Customer.expects(:retrieve).with(stripe_customer_token).returns(customer)
      end

      it "should return stripe user" do
        stripe_customer = user.create_or_retrieve_stripe_customer
        stripe_customer.should == customer
      end
    end

  end

end
