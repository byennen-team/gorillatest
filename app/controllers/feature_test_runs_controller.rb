class FeatureTestRunsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_project_and_feature
  before_filter :find_feature_test_run, except: [:index]

  def index
    @test_runs = @feature.test_runs
  end

  def show; end

  private

    def find_project_and_feature
      @project = current_user.projects.find(params[:project_id])
      @feature = @project.features.find(params[:feature_id])
    end

    def find_feature_test_run
      @test_run = @feature.test_runs.find(params[:id])
    end

end
