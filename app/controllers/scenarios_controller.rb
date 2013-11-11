class ScenariosController < ApplicationController

  before_filter :find_project
  before_filter :find_feature
  before_filter :find_scenario, except: [:index, :new, :create]

  def new
    @scenario = @feature.scenarios.new
  end

  def create
    @scenario = @feature.scenario.new(params[:scenario])
    respond_to do |format|
      format.html { redirect_to feature_path(@feature) }
    end
  end

  def edit; end

  def update
    @scenario.attributes = params[:scenario]
    if @scenario.save
      respond_to do |format|
        format.html { redirect_to feature_path(@feature) }
      end
    end
  end

  def destroy
    if @scenario.destroy
      respond_to do |format|
        format.html { redirect_to feature_path(@feature) }
      end
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_feature
    @feature = @project.feature.find(params[:feature_id])
  end

  def find_scenario
    @scenario = @feature.scenario.find(params[:id])
  end

end
