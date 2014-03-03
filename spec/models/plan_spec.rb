require 'spec_helper'

describe Plan do

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:seconds_available) }
  it { should have_many(:users) }


  context "unlimited plan" do
    let(:plan) { create(:plan, seconds_available: 60*60*1000)}

    it "#unlimited? returns true" do
      expect(plan.unlimited?).to eq true
    end
  end

  context "limited plan" do
    let(:plan) { create(:plan) }

    it "#unlimited? returns false" do
      expect(plan.unlimited?).to eq false
    end

    it "minutes_available" do
      expect(plan.minutes_available).to eq 60
    end
  end
end
