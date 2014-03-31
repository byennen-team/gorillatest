class ScenariosController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_project
  # before_filter :find_feature
  before_filter :find_scenario, except: [:index, :new, :create]


  def show; end

  # def new
  #   @scenario = @feature.scenarios.new
  # end

  # def create
  #   @scenario = @feature.scenarios.new(scenario_params)
  #   if @scenario.save
  #     respond_to do |format|
  #       format.html { redirect_to project_feature_path(@project, @feature) }
  #     end
  #   end
  # end

  # def edit; end

  # def update
  #   @scenario.attributes = scenario_params
  #   if @scenario.save
  #     respond_to do |format|
  #       format.html { redirect_to project_feature_path(@project, @feature) }
  #     end
  #   end
  # end

  def destroy
    if @scenario.destroy
      respond_to do |format|
        format.html { redirect_to project_feature_path(@project, @feature) }
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
      TestWorker.perform_async("queue_tests", "Scenario", test_run.id.to_s)
      respond_to do |format|
        format.html { redirect_to project_feature_scenario_test_run_path(@project, @feature, @scenario, test_run) }
        format.json { }
      end
    end
  end

  private

  def scenario_params
    params.require(:scenario).permit(:name, :window_x, :window_y, :start_url)
  end

end
