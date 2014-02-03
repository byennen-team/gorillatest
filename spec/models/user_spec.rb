require 'spec_helper'

describe User do

  describe 'on create' do

    let!(:user) { create(:user) }

    it "should create a company" do
      expect(user.company.name).to eq(user.company_name)
    end

    it "sends welcome email after creation" do
      ActionMailer::Base.deliveries.last.to.should eq [user.email]
    end

  end
end
