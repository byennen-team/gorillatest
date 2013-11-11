class ProjectsController < ApplicationController
  
  before_filter :find_company
  before_filter :find_project, except: [:index, :new, :create]

  def show
    @features = @project.features
  end

  def new; @project = Project.new; end

  def create
    @project = @company.projects.build(project_params)
    @project.company_id = @company.id
    if @project.save
      respond_to do |format|
        format.html { redirect_to dashboard_companies_path }
      end
    end
  end

  def edit; end

  def update
    @project.attributes = params[:project]
    if @project.save
      respond_to do |format|
        format.html { redirect_to company_path }
      end
    end
  end

  def destroy
    if @project.destroy
      respond_to do |format|
        format.html { redirect_to company_path } 
      end
    end
  end

  private

  def find_company
    @company = current_user.company
  end

  def find_project
    @project = @company.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :url)
  end

end
