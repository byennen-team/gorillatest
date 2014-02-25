require 'spec_helper'

describe FeatureTestRun do

  describe 'relations' do

    it { should belong_to(:feature) }
    it { should embed_many(:browser_tests) }

  end

  describe 'methods' do

    let(:project)  { create(:project) }
    let(:feature)  { create(:feature, project: project) }
    let(:test_run) { create(:feature_test_run, feature: feature) }

    it "should have a project" do
      expect(test_run.project).to eq(project)
    end

    it "should have a name" do
      expect(test_run.name).to eq(feature.name)
    end

    it "should have a start notification message" do
      msg = "Test Run Started For: #{project.name} - #{feature.name} - #{test_run.number}: "
      msg += "#{ENV['API_URL']}/projects/#{project.slug}/features/#{feature.slug}/test_runs/#{test_run.id}"
      expect(test_run.start_notification_message).to eq(msg)
    end

    describe 'complete_notification_message' do

      context 'with failed status' do

        before do
          test_run.stubs(:status).returns('fail')
        end

        it "should have a failed notification message" do
          msg = "Test Run failed For: #{project.name} - #{feature.name} - #{test_run.number}: "
          msg += "#{ENV['API_URL']}/projects/#{project.slug}/features/#{feature.slug}/test_runs/#{test_run.id}"
          expect(test_run.complete_notification_message).to eq msg
        end

      end

      context 'with passed status' do

        before do
          test_run.stubs(:status).returns('pass')
        end

        it "shoud have a passed complete notification message" do
          msg = "Test Run passed For: #{project.name} - #{feature.name} - #{test_run.number}: "
          msg += "#{ENV['API_URL']}/projects/#{project.slug}/features/#{feature.slug}/test_runs/#{test_run.id}"
          expect(test_run.complete_notification_message).to eq(msg)
        end

      end

    end

  end

end
