require 'spec_helper'

describe PlanCustomer do
  class Subject
    include Mongoid::Document
    include Mongoid::Timestamps
    include PlanCustomer
  end

  subject { Subject.new }
  it { should belong_to(:plan) }
  it { should have_one(:credit_card) }

  describe 'creating stripe customer' do

    let(:user) { create(:user) }
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
