class FeaturesController < ApplicationController

  before_filter :authenticate_user!
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

  def run
    test_run = @feature.test_runs.build({user: current_user, platforms: params[:browsers]})
    if test_run.save
      TestWorker.perform_async("queue_tests", "Feature", test_run.id.to_s)
      respond_to do |format|
        format.html { redirect_to project_feature_test_run_path(@project, @feature, test_run) }
        format.json { }
      end
    end
  end

  private

  def feature_params
    params.require(:feature).permit(:name)
  end

end
