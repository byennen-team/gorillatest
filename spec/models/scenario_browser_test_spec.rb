require 'spec_helper'

describe ScenarioBrowserTest do

  describe 'relations' do

    it { should be_embedded_in(:test_run) }
    it { should embed_one(:test_history) }

  end

  describe 'methods' do

    let(:scenario) { create(:scenario) }
    let(:test_run) { create(:scenario_test_run, scenario: scenario) }
    let(:browser_test) { create(:scenario_browser_test, test_run: test_run)}

    it "should have a channel name" do
      expect(browser_test.channel_name).to eq("#{test_run.id}_linux_firefox_channel")
    end

  end

end
