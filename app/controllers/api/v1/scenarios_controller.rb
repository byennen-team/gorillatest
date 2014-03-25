class Api::V1::ScenariosController < Api::V1::BaseController

  respond_to :json, :js

  before_filter :find_feature

  def index
    @scenarios = @feature.scenarios
    render json: @scenarios, root: false
  end

  def show
    @scenario = @feature.scenarios.find(params[:id])
    render json: @scenario, root: false
  end

  def create
    @scenario = @feature.scenarios.new(scenario_params)
    if @scenario.save
      render json: @scenario, root: false
    else
      render json: {errors: @scenario.errors.to_a}.to_json, status: 400
    end
  end

  def update
    @scenario = @feature.scenario.find(params[:id])
    @scenario.attributes = scenario_attributes
    if @scenario.save
      render json: @scenario, root: false
    end
  end

  private

  # Need to figure out how features work into scenarios
  def find_feature
    @feature = current_project.features.find(params[:feature_id])
  end

  def scenario_params
    params.require(:scenario).permit(:name, :url, :window_x, :window_y, :start_url)
  end

end
