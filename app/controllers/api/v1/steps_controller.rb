class Api::V1::StepsController < Api::V1::BaseController

  before_filter :find_scenario

  respond_to :json

  def index
    @steps = @scenario.steps
    render json: @steps, root: false
  end

	def create
    if @step = @scenario.steps.create(step_params)
      render json: @step, root: false
    end
	end

	private


	def find_scenario
    @scenario = current_project.scenarios.find(params[:scenario_id])
  end

  def step_params
    params.require(:step).permit(:event_type, :locator_type, :locator_value, :text)
  end



end
