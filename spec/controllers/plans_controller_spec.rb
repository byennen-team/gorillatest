require 'spec_helper'

describe PlansController do

  let!(:free_plan)           { create(:plan) }
  let!(:stripe_plan)         { Stripe::Plan.create(amount: 0,
                                                   interval: 'month',
                                                   name: 'Free',
                                                   currency: 'usd',
                                                   id: 'free') }
  let!(:non_free_plan)       { create(:starter_plan) }
  let!(:stripe_starter_plan) { Stripe::Plan.create(amount: 1200,
                                                   interval: 'month',
                                                   name: 'Starter',
                                                   currency: 'usd',
                                                   id: 'starter') }

  describe '#upgrade' do

    context 'with valid card' do
    end

    context 'with failing card' do

      let!(:stripe_card_token)    { StripeMock.generate_card_token(last4: "4242", exp_year: 2016) }
      let!(:user)                 { create(:user) }
      let(:user_credit_card)      { user.credit_cards.create({stripe_token: stripe_card_token}) }

      before do
        user.update_attribute(:confirmed_at, Time.now-1.day)
        StripeMock.prepare_card_error(:card_declined, :update_subscription)
        sign_in user
        post :upgrade, stripe_token: stripe_card_token, id: non_free_plan.id.to_s
      end

      it "should render upgrade change plan on an error" do
        expect(response).to render_template('upgrade')
      end

      it "should set the flash alert to 'Your card could not be processed" do
        expect(flash[:alert]).to eq('Your card could not be processed')
      end

    end

  end

  describe '#downgrade' do

    context 'when able to downgrade' do

      let!(:stripe_card_token)    { StripeMock.generate_card_token(last4: "4242", exp_year: 2016) }
      let!(:user)                 { create(:user) }
      let(:user_credit_card)      { user.credit_cards.create({stripe_token: stripe_card_token}) }

      before do
        stripe_customer = user.create_or_retrieve_stripe_customer
        stripe_customer.default_card = user_credit_card.stripe_id
        stripe_customer.save
        post :downgrade, id: free_plan.id.to_s
      end

      it "should have a downgraded plan" do
        expect(user.plan).to eq(free_plan)
      end

    end

    context 'when not able to downgrade' do
    end

  end

end
