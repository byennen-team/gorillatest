class FeaturesController < ApplicationController

  before_filter :find_project
  before_filter :find_feature, except: [:index, :new, :create]

  def index
    @features = @project.features
  end

  def show
  end

  def new
    @feature = @project.features.new
  end

  def create
    @feature = @project.features.new(params[:feature])
    if @feature.save
      respond_to do |format|
        format.html { redirect_to project_path(@project) } 
      end
    end
  end

  def update
    @feature.attributes = params[:feature]
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
    @project = Project.find(params[:project_id])
  end

  def find_feature
    @feature = @project.features.find(params[:id])
  end

end
