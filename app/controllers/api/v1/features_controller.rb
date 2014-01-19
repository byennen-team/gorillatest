class Api::V1::FeaturesController < Api::V1::BaseController

  before_filter :find_project

	def index
    @features = @project.features
    respond_to do |format|
      format.json { render json: @features }
    end
	end

	def show
    @feature = @project.features.find(params[:id])
    respond_to do |format|
      format.json { render json: @feature }
    end
  end

  def create
    @feature = @project.features.build(feature_params)
    if @feature.save
      respond_to do |format|
        format.json {render json: @feature}
      end
    end
  end

  def destroy
  end

  private

  def feature_params
    params.require(:feature).permit(:name)
  end

  def find_project
    @project = current_company.projects.find(params[:project_id])
  end

end
