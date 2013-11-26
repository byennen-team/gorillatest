require 'spec_helper'

describe User do

  describe 'on create' do

    before do
      @user = User.create!({email: "test@test.com", password: "test1234", password_confirmation: "test1234",
                           company_name: "Test Company"})
    end

    it "should create the user" do
      expect(@user.company.name).to eq("Test Company")
    end

  end
end
