require 'spec_helper'

describe PlanCustomer do
  let!(:plan) { create(:plan) }
  let!(:stripe_plan) { Stripe::Plan.create(amount: 0,
                                           interval: 'month',
                                           name: 'Free',
                                           currency: 'usd',
                                           id: 'free')}

  let(:user) { create(:user) }

  describe 'creating stripe customer and initial plan' do

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

  describe 'upgrade plan' do

    let!(:non_free_plan)       { create(:starter_plan) }
    let!(:stripe_starter_plan) { Stripe::Plan.create(amount: 1200,
                                                     interval: 'month',
                                                     name: 'Starter',
                                                     currency: 'usd',
                                                     id: 'starter')}
    let!(:stripe_card_token)    { StripeMock.generate_card_token(last4: "4242", exp_year: 2016) }
    let!(:user)                 { create(:user) }
    let(:user_credit_card)      { user.create_credit_card({stripe_token: stripe_card_token}) }

    before do
      # Update the stripe customer card default mocking doesn't set default card
      stripe_customer = user.create_or_retrieve_stripe_customer
      stripe_customer.default_card = user_credit_card.stripe_id
      stripe_customer.save
      user.subscribe_to(non_free_plan)
    end

    it "should have an upgraded plan" do
      expect(user.plan).to eq(non_free_plan)
    end

    it "should have an upgraded stripe plan" do
      expect(user.stripe_subscription.plan.id).to eq(stripe_starter_plan.id)
    end

  end

  describe '#can_downgrade' do

    let!(:non_free_plan) { create(:starter_plan) }
    let!(:user)          { create(:user, plan: non_free_plan) }

    context 'with more projects that free' do

      before do
        (0..3).each do |i|
          project = Project.create!(name: "Project#{i}", url: "http://test#{i}.io", user_id: user.id)
          project_user = ProjectUser.create(user_id: user.id, project_id: project.id, rights: "owner")
        end
      end

      it "should return false for free plan" do
        expect(user.can_downgrade?(plan)).to eq false
      end

    end

    context 'with more users on a project than allowed' do

      let!(:project)       { create(:project, user_id: user.id) }
      let!(:project_owner) { create(:project_user, user: user, project: project, rights: "owner") }

      before do
        (0..3).each do |i|
          u = create(:user)
          project_user = ProjectUser.create(user_id: u.id, project_id: project.id, rights: "member")
        end
      end

      it "should return false for free plan" do
        expect(user.can_downgrade?(plan)).to eq(false)
      end

    end

    context 'with more minutes than plan allows' do

      let!(:testing_allowance) { create(:testing_allowance, timeable: user, seconds_used: non_free_plan.seconds_available) }

      it "should return false for free plan" do
        expect(user.can_downgrade?(plan)).to eq(false)
      end

    end


  end


end
