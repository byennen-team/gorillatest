class ScenariosController < ApplicationController

  before_filter :find_project
  before_filter :find_feature
  before_filter :find_scenario, except: [:index, :new, :create]

  def show; end

  def new
    @scenario = @feature.scenarios.new
  end

  def create
    @scenario = @feature.scenarios.new(scenario_params)
    if @scenario.save
      respond_to do |format|
        format.html { redirect_to project_feature_path(@project, @feature) }
      end
    end
  end

  def edit; end

  def update
    @scenario.attributes = scenario_params
    if @scenario.save
      respond_to do |format|
        format.html { redirect_to project_feature_path(@project, @feature) }
      end
    end
  end

  def destroy
    if @scenario.destroy
      respond_to do |format|
        format.html { redirect_to project_feature_path(@project, @feature) }
      end
    end
  end

  def run
    params[:browsers].each do |browser|
      test_run = @scenario.test_runs.create!({browser: browser.split('_').last, platform: browser.split('_').first})
      @scenario.steps.each do |step|
        test_run.steps << Step.new(step.attributes.except("_id").except("updated_at").except("created_at"))
      end
      test_run.save
      TestWorker.perform_async(test_run.id.to_s, current_user.id.to_s)
    end
    respond_to do |format|
      format.html { redirect_to project_feature_path(@project, @feature) }
      format.json { }
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_feature
    @feature = @project.features.find(params[:feature_id])
  end

  def find_scenario
    @scenario = @feature.scenarios.find(params[:id])
  end

  def scenario_params
    params.require(:scenario).permit(:name, :window_x, :window_y, :start_url)
  end


end
