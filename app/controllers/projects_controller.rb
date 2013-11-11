class ProjectsController < ApplicationController
  
  before_filter :find_project, except: [:index, :new, :create]

  def show
    @features = @project.features
  end

  def new; @project = Project.new; end

  def create
    @project = @company.projects.new(params[:project])
    if @project.save
      respond_to do |format|
        format.html { redirect_to company_path }
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

  def find_project
    @project = Project.find(params[:id])
  end

end
