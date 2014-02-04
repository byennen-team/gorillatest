class FeaturesController < ApplicationController

  before_filter :find_project
  before_filter :find_feature, except: [:index, :new, :create]

  def index
    @features = @project.features
  end

  def show
    @feature = @project.features.find(params[:id])
  end

  def new
    @feature = @project.features.new
  end

  def create
    @feature = @project.features.build(feature_params)
    if @feature.save
      respond_to do |format|
        format.html { redirect_to project_feature_path(@project, @feature) }
      end
    end
  end

  def update
    @feature.attributes = feature_params
    if @feature.save
      respond_to do |format|
        format.html { redirect_to project_path(@project) }
      end
    end
  end

  def destroy
    if @feature.destroy
      respond_to do |format|
        format.html { redirect_to project_path(@project) }
      end
    end
  end

  private

  def find_project
    @project = current_user.projects.find(params[:project_id])
  end

  def find_feature
    @feature = @project.features.find(params[:id])
  end

  def feature_params
    params.require(:feature).permit(:name)
  end

end
