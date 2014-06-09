require 'spec_helper'

describe Heroku::ResourcesController do

  include BasicAuthHelper

    let!(:plan)             { create(:plan, stripe_id: "test", name: "Test") }
    let!(:stripe_plan)      { Stripe::Plan.create(amount: 0,
                                                  interval: 'month',
                                                  name: 'Test',
                                                  currency: 'usd',
                                                  id: 'test')}

    let!(:free_plan)        { create(:plan) }
    let!(:free_stripe_plan) { Stripe::Plan.create(amount: 0,
                                                  interval: 'month',
                                                  name: 'Free',
                                                  currency: 'usd',
                                                  id: 'free')}


  before :each do
    http_login('gorillatest', 'd1079df84eb12770c6d068b778024553')
  end

  describe '#create' do

    before do
      post :create, resource: {heroku_id: "app1234@heroku.com",plan: plan.stripe_id}, format: :json
    end

    subject { assigns(:user) }

    specify { expect(subject.email).to eq "app1234@heroku.com" }
    specify { expect(subject.confirmed?).to eq true }
    specify { expect(subject.heroku_user).to eq true }
    specify { expect(subject.projects.size).to eq 0 }
    specify { expect(subject.stripe_customer_token).to be_nil }
    specify { expect(subject.plan).to eq plan }
    specify { expect(HerokuWorker).to have_enqueued_job("fetch_project", subject.id.to_s) }

  end

  describe '#destroy' do

    let!(:user) { create(:user) }

    before do
      post :destroy, id: user.id
    end

    specify { expect(assigns(:user).deleted_at).to_not be_nil }
    specify { expect(assigns(:user).projects.size).to eq 0 }

  end

  describe '#update' do
  end

end
