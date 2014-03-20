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
    let(:stripe_card_token)    { StripeMock.generate_card_token(last4: "4242",
                                                                exp_month: Time.now.month,
                                                                exp_year: (Time.now+1.year).year,
                                                                name: "Donald Duck",
                                                                type: "Visa") }
    let!(:credit_card) { user.credit_cards.create({stripe_token: stripe_card_token}) }
    let(:stripe_plan_id) { plan.stripe_id}

    specify { expect(credit_card.last4).to eq("4242") }
    specify { expect(credit_card.stripe_id).to_not be_nil }
    specify { expect(credit_card.cc_type).to eq("Visa") }
    specify { expect(credit_card.name).to eq("Donald Duck") }
    specify { expect(credit_card.default).to be_true }
    specify { expect(user.reload.create_or_retrieve_stripe_customer.default_card).to eq(credit_card.stripe_id) }

  end

  describe 'adding  a second card' do
    let!(:plan) { create(:plan, stripe_id: "free") }
    let!(:user) { create(:user) }
    let(:stripe_card_token)    { StripeMock.generate_card_token(last4: "4242",
                                                                exp_month: Time.now.month,
                                                                exp_year: (Time.now+1.year).year,
                                                                name: "Donald Duck",
                                                                type: "Visa") }
    let!(:credit_card1) { user.credit_cards.create({stripe_token: stripe_card_token}) }
    let!(:credit_card2) { user.credit_cards.create({stripe_token: stripe_card_token}) }
    let(:stripe_plan_id) { plan.stripe_id}

    specify { expect(credit_card2.default).to be_true }
    specify { expect(credit_card1.default).to_not be_true }
    specify { expect(user.create_or_retrieve_stripe_customer.default_card).to eq credit_card2.stripe_id }

  end


  describe 'deleting a credit card' do

    let!(:plan) { create(:plan, stripe_id: "free") }
    let!(:user) { create(:user) }
    let(:stripe_card_token)    { StripeMock.generate_card_token(last4: "4242",
                                                                exp_month: Time.now.month,
                                                                exp_year: (Time.now+1.year).year,
                                                                name: "Donald Duck",
                                                                type: "Visa") }
    let!(:credit_card) { user.credit_cards.create({stripe_token: stripe_card_token}) }
    let(:stripe_plan_id) { plan.stripe_id}


    context 'with one card' do

      specify { expect { credit_card.destroy }.to raise_error(DefaultCreditCardUndeletable) }


    end

    context 'with multiple cards' do

      let!(:user) { create(:user) }
      let!(:credit_card) { user.credit_cards.create({stripe_token: stripe_card_token}) }
      let!(:credit_card2) { user.credit_cards.create(stripe_token: stripe_card_token) }
      let(:stripe_user)   { user.reload.create_or_retrieve_stripe_customer }
      let!(:stripe_card_id) { credit_card.stripe_id }

      before do
        credit_card.destroy
      end

      specify { expect { user.create_or_retrieve_stripe_customer.cards.retrieve(stripe_card_id) }.to raise_error(Stripe::InvalidRequestError) }

    end

  end

end
