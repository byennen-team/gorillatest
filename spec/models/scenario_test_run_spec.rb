require 'spec_helper'

describe ScenarioTestRun do
  let(:scenario) { create(:scenario)}
  let(:test_run) { create(:scenario_test_run, scenario: scenario) }

  context "all tests passed" do
    before do
      2.times do
        create(:scenario_browser_test, status: "pass", test_run: test_run)
      end
    end

    it "status returns true iZf all tests passed" do
      expect(test_run.status).to eq "pass"
    end
  end

  context "one test failed" do
    before do
      create(:scenario_browser_test, status: "pass", test_run: test_run)
      create(:scenario_browser_test, status: "fail", test_run: test_run)
    end

    it "returns fail" do
      expect(test_run.status).to eq "fail"
    end
  end

  context "no status on tests" do
    before do
      create(:scenario_browser_test, status: nil, test_run: test_run)
      create(:scenario_browser_test, status: "pass", test_run: test_run)
      create(:scenario_browser_test, status: "fail", test_run: test_run)
    end

    it "return running" do
      expect(test_run.status).to eq "running"
    end
  end

end
