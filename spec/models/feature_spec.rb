require 'spec_helper'

describe Feature do

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should belong_to(:project) }

  context "slug id" do
    let(:feature) { create(:feature, name: "Customer checkout") }

    it "created based on feature name" do
      expect(feature.slug).to eq "customer-checkout"
    end

    it "can be used to find feature" do
      expect(Feature.find(feature.slug)).to eq feature
    end
  end

end
