class Api::V1::ProjectsController < Api::V1::BaseController

  respond_to :json, :js

  def index
    @projects = @current_company.projects.all
    respond_with(@projects)
  end

  def show
    @project = @current_company.projects.find(params[:id])
    respond_with(@project)
  end

end
