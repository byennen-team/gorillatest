class ScenariosController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_project
  before_filter :find_scenario, except: [:index, :new, :create]


  def show; end

  def destroy
    if @scenario.destroy
      respond_to do |format|
        format.html { redirect_to project_path(@project) }
      end
    end
  end

  def run
    test_run = @scenario.test_runs.build({user: current_user, platforms: params[:browsers], queued_at: Time.now})
    if test_run.save
      test_run.platforms.each do |p|
        browser_test = test_run.browser_tests.create!({browser: p.split('_').last,
                                                    platform: p.split('_').first})
      end
      unless @scenario.demo?
        TestWorker.perform_async("queue_tests", "Scenario", test_run.id.to_s)
      end

      respond_to do |format|
        format.html do
          redirect_path_args = @scenario.demo ? {test: "run"} : {}
          redirect_to project_test_test_run_path(@project, @scenario.slug, test_run, redirect_path_args)
        end
        format.json { }
      end
    end
  end

  private

  def scenario_params
    params.require(:scenario).permit(:name, :window_x, :window_y, :start_url)
  end

end
