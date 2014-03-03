require 'spec_helper'

describe TestingAllowance do

  it { should belong_to(:timeable) }

  let(:allowance) { create(:testing_allowance) }

  it "#minutes_used returns minutes used this month" do
    expect(allowance.minutes_used).to eq allowance.seconds_used / 60
  end

  describe "for current month" do
    let!(:current_month_allowance) { create(:testing_allowance) }
    let!(:previous_month_allowance) { create(:testing_allowance, start_at: 1.month.ago.beginning_of_month)}

    it "returns current month's allowance" do
      expect(TestingAllowance.current_month).to eq current_month_allowance
    end
  end
end
