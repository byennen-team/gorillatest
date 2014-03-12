require 'spec_helper'

describe CreditCard do

  let!(:stripe_plan) { Stripe::Plan.create(amount: 0,
                                           interval: 'month',
                                           name: 'Free',
                                           currency: 'usd',
                                           id: 'free')}

  it { should belong_to(:user) }
  it { should validate_presence_of(:stripe_id) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:cc_type) }
  it { should validate_presence_of(:last4) }


  describe 'saving credit card info' do

    let!(:plan) { create(:plan, stripe_id: "free") }
    let!(:user) { create(:user) }
    let(:credit_card) { stub('credit_card', id: "12345", name: "Donald Duck",
                                            last4: "1111", type: "Visa",
                                            exp_month: "04", exp_year: "2016") }
    let(:stripe_customer_token) {"12344555"}
    let(:customer) {stub('customer', description: "#{user.first_name} #{user.last_name}",
                                     email: user.email,
                                     id: stripe_customer_token,
                                     subscriptions: [])}
    let(:stripe_token) {"12233333"}
    let(:stripe_plan_id) { plan.stripe_id}

    before do
      user.update_attribute(:stripe_customer_token, stripe_customer_token)
      Stripe::Customer.stubs(:retrieve).with(stripe_customer_token).returns(customer)
      cards = stub('cards')
      customer.stubs(:cards).returns(cards)
      cards.stubs(:create).with({card: stripe_token}).returns(credit_card)
      customer.subscriptions.stubs(:create).with(:plan => plan).returns(OpenStruct.new(plan: plan))
    end

    it "should store the payment info" do
      cc = user.create_credit_card({stripe_token: stripe_token})
      cc.last4.should == "1111"
      cc.stripe_id.should == "12345"
      cc.cc_type.should == "Visa"
      cc.name.should == "Donald Duck"
    end

    it "should create Stripe subscription to cheapest plan" do
      # customer.subscriptions.expects(:create).with(:plan => plan).returns(OpenStruct.new(plan: plan.stripe_id))
      # customer.subscriptions.stubs(:first).returns(OpenStruct.new(plan: plan.stripe_id))
      # cc = user.create_credit_card({stripe_token: stripe_token})
      # cc.user.create_or_retrieve_stripe_customer.subscriptions.first.plan.should == "free"
    end
  end

end
