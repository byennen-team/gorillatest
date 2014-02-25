require 'spec_helper'

describe Scenario do

  it { should validate_uniqueness_of(:name).scoped_to(:feature)}
  it { should validate_presence_of(:name)}
  it { should validate_presence_of(:window_x) }
  it { should validate_presence_of(:window_y) }

  context "soft delete" do
    let!(:scenario) {create(:scenario)}

    before do
      scenario.destroy
    end

    it "gets soft deleted on destroy" do
      expect(Scenario.deleted).to include scenario
    end

    it "name validation scope excludes deleted items" do
      expect(create(:scenario, name: scenario.name)).to be_valid
    end
  end

  context "slug id" do
    let(:scenario) { create(:scenario, name: "User can sign in with valid e-mail address")}

    it "gets created using scenario name" do
      expect(scenario.slug).to eq "user-can-sign-in-with-valid-e-mail-address"
    end

    it "can be used to find scenario" do
      expect(Scenario.find(scenario.slug)).to eq scenario
    end


  end
end
