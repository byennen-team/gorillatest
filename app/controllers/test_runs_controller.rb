class TestRunsController < ApplicationController

  before_filter :authenticate_user!

  before_filter :find_project, :find_feature, :find_scenario

  def show
    @test_run = @scenario.test_runs.find_by(number: params[:id])
  end

  private

end
