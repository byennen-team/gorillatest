class ProjectsController < ApplicationController

  before_filter :find_project, except: [:index, :new, :create]

  def index
    @projects = current_user.projects
  end

  def show
    @features = @project.features
  end

  def new; @project = Project.new; end

  def create
    @project = current_user.projects.build(project_params)
    @project.user_id = current_user.id
    if @project.save
      respond_to do |format|
        format.html { redirect_to project_path(@project) }
      end
    end
  end

  def edit; end

  def update
    @project.attributes = params[:project]
    if @project.save
      respond_to do |format|
        format.html { redirect_to dashboard_path }
      end
    end
  end

  def destroy
    if @project.destroy
      respond_to do |format|
        format.html { redirect_to projects_path }
      end
    end
  end

  private

  def find_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :url)
  end

end
