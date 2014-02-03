class Api::V1::FeaturesController < Api::V1::BaseController

  before_filter :find_project

	def index
    @features = current_project.features
    render json: @features
	end

	def show
    @feature = current_project.features.find(params[:id])
    render json: @feature
  end

  def create
    @feature = current_project.features.build(feature_params)
    if @feature.save
      render json: @feature
    end
  end

  def destroy
  end

  private

  def feature_params
    params.require(:feature).permit(:name)
  end

end
