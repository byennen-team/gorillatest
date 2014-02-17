class ProjectTestRunsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_project

  def index
    @test_runs = @project.test_runs
  end

  def show
    @test_run = @project.test_runs.find(params[:id])
  end

end
