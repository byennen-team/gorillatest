require 'spec_helper'

describe ProjectTestRun do

  describe 'relationships' do

    it { should embed_many(:browser_tests) }
    it { should belong_to(:project) }

  end

  describe 'methods' do

    let(:project) { create(:project) }
    let(:test_run) { create(:project_test_run, project: project) }

    it "should have a name" do
      expect(test_run.name).to eq(project.name)
    end

    it "should have a number" do
      expect(test_run.number).to eq(2)
    end

    it "should have a nil feature" do
      expect(test_run.feature).to be_nil
    end

    it "should have a start notifiation message" do
      message = "Test Run Started For: #{project.name} - #{test_run.number}"
      message += " #{ENV["API_URL"]}/projects/#{project.id}/test_runs/#{test_run.id}"
      expect(test_run.start_notification_message).to eq(message)
    end

    it "should have a complete notification message" do
    end

  end

end