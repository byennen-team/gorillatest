require 'spec_helper'

describe CreditCardsController do

  let!(:plan)                 { create(:plan) }
  let!(:stripe_plan)          { Stripe::Plan.create(amount: 0,
                                                    interval: 'month',
                                                    name: 'Free',
                                                    currency: 'usd',
                                                    id: 'free') }
  let!(:user)                 { create(:user) }
  let(:stripe_card_token)     { StripeMock.generate_card_token(last4: "4242",
                                                              exp_month: Time.now.month,
                                                              exp_year: (Time.now+1.year).year,
                                                              name: "Donald Duck",
                                                              type: "Visa") }

  before do
    user.confirm!
    sign_in user
  end

  describe '#index' do

    let!(:credit_card1)      { user.credit_cards.create(stripe_token: stripe_card_token) }
    let!(:credit_card2)      { user.credit_cards.create(stripe_token: stripe_card_token) }

    before do
      get :index
    end

    specify { expect(assigns(:default_credit_card)).to eq(credit_card2) }
    specify { expect(assigns(:credit_cards)).to eq([credit_card1]) }

  end

  describe '#create' do

    before do
      post :create, stripe_token: stripe_card_token
    end

    it { should redirect_to credit_cards_path }

    subject { assigns(:credit_card) }

    specify { expect(subject.last4).to eq "4242" }
    specify { expect(subject.exp_month).to eq Time.now.month.to_s }
    specify { expect(subject.exp_year).to eq (Time.now+1.year).year.to_s }
    specify { expect(subject.name).to eq "Donald Duck" }
    specify { expect(subject.default).to be_true }
    specify { expect(user.create_or_retrieve_stripe_customer.default_card).to eq assigns(:credit_card).stripe_id }

  end

  describe '#destroy' do

    context 'when default' do

      let!(:credit_card) { user.credit_cards.create(stripe_token: stripe_card_token) }

      before do
        post :destroy, id: credit_card.id
      end

      it { should redirect_to credit_cards_path }
      it { should set_the_flash.to("Credit Card Could not be deleted") }

    end

    context 'when not default' do

      let!(:credit_card1) { user.credit_cards.create(stripe_token: stripe_card_token) }
      let!(:credit_card2) { user.credit_cards.create(stripe_token: stripe_card_token) }

      before do
        post :destroy, id: credit_card1.id
      end

       it { should redirect_to credit_cards_path }
       it { should set_the_flash.to("Credit Card was deleted") }

    end

  end


end
