require 'spec_helper'

describe Company do

  it { should have_many :projects }

  describe "on create" do

  	let(:company) { FactoryGirl.create(:company) }

  	it "should have a api key" do
  		expect(company.api_key.length).to equal(32)
    end

  end

end
