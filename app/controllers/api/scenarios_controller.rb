class Api::ScenariosController < Api::BaseController

  respond_to :json, :js

  before_filter :find_project
  before_filter :find_feature

  def index
    @scenarios = @feature.scenarios
    respond_with(@scenarios)
  end

  def show
    @scenario = @feature.scenarios.find(params[:id])
    respond_with(@scenario)
  end

  def create
    @scenario = @feature.scenarios.new(scenario_params)
    if @scenario.save
      respond_to do |format|
        format.json { render json: @scenario }
      end
    end
  end

  def update
    @scenario = @features.scenario.find(params[:id])
    @scenario.attributes = scenario_attributes
    if @scenario.save
      respond_with(@scenario)
    end
  end

  private

  def find_project
    @project = @current_company.projects.find(params[:project_id])
  end

  # Need to figure out how features work into scenarios
  def find_feature
    @feature = @project.features.first
  end

  def scenario_params
    params.require(:scenario).permit(:name, :url)
  end


end
