require 'spec_helper'

describe RegistrationsController do


  describe '#upgrade' do

    let!(:free_plan)           { create(:plan) }
   let!(:stripe_plan) { Stripe::Plan.create(amount: 0,
                                         interval: 'month',
                                         name: 'Free',
                                         currency: 'usd',
                                         id: 'free')}
    let!(:non_free_plan)       { create(:starter_plan) }
    let!(:stripe_starter_plan) { Stripe::Plan.create(amount: 1200,
                                                     interval: 'month',
                                                     name: 'Starter',
                                                     currency: 'usd',
                                                     id: 'starter')}

    context 'with valid card' do
    end

    context 'with failing card' do

      let!(:stripe_card_token)    { StripeMock.generate_card_token(last4: "4242", exp_year: 2016) }
      let!(:user)                 { create(:user) }
      let(:user_credit_card)      { user.create_credit_card({stripe_token: stripe_card_token}) }

      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        StripeMock.prepare_card_error(:card_declined, :update_subscription)
        post :upgrade, stripe_token: stripe_card_token, plan_id: non_free_plan.id.to_s
      end

      it "should render upgrade change plan on an error" do
        expect(response).to render_template('upgrade')
      end

      it "should set the flash alert to 'Your card could not be processed" do
        expect(flash[:alert]).to eq('Your card could not be processed')
      end

    end

  end

end
