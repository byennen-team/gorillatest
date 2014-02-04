class TestRunsController < ApplicationController

  def show
    @test_run = TestRun.find(params[:id])
    @project = @test_run.scenario.feature.project
    @feature = @test_run.scenario.feature
    @scenario = @test_run.scenario
  end

  private



end