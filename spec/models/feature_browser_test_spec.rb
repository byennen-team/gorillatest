require 'spec_helper'

describe FeatureBrowserTest do

  describe 'relations' do

    it { should be_embedded_in(:test_run) }
    it { should embed_one(:test_history) }

  end

  describe 'methods' do

    let(:feature)      { create(:feature) }
    let(:test_run)     { create(:feature_test_run, feature: feature) }
    let(:browser_test) { create(:feature_browser_test, test_run: test_run) }

    it "should have a channel name" do
      expect(browser_test.channel_name).to eq("#{test_run.id}_linux_firefox_channel")
    end

  end

end
