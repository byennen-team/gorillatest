class Api::V1::StepsController < Api::V1::BaseController

  skip_before_action :verify_authenticity_token

  before_filter :find_project
  before_filter :find_feature
  before_filter :find_scenario

  respond_to :json

  def index
    @steps = @scenario.steps
    respond_to do |format|
      format.json { render json: @steps }
    end
  end
  
	def create
    if @step = @scenario.steps.create(step_params)
      respond_to do |format|
        format.json { render json: @step }
      end
    end
	end

	private

  def find_project
    @project = current_company.projects(params[:project_id])
  end

  def find_feature
    @feature = @project.features.find(params[:feature_id])
  end

	def find_scenario
    @scenario = @feature.scenarios.find(params[:scenario_id])
  end

  def step_params
    params.require(:step).permit(:event_type, :locator_type, :locator_value, :text)
  end



end
