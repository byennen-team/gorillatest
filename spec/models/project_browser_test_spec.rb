require 'spec_helper'

describe ProjectBrowserTest do

  describe 'relations' do

    it { should be_embedded_in(:test_run) }
    it { should embed_one(:test_history) }
  end

  describe 'methods' do

    let(:project)      { create(:project) }
    let(:test_run)     { create(:project_test_run, project: project) }
    let(:browser_test) { create(:project_browser_test, test_run: test_run)}

    it "should have a channel name" do
      expect(browser_test.channel_name).to eq("#{test_run.id}_linux_firefox_channel")
    end

  end

end
