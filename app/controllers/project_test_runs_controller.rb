class ProjectTestRunsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_project

  def index
    @test_runs = @project.test_runs
  end

  def show
    @test_run = @project.test_runs.find(params[:id])
    @num_of_tests = @project.scenarios.lt(created_at: @test_run.created_at).count
  end

end
