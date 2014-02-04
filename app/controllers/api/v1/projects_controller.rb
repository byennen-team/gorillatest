class Api::V1::ProjectsController < Api::V1::BaseController

  respond_to :json, :js

  def index
    @projects = [@current_project]
    respond_with(@projects)
  end

  def show
    @project = current_project
    respond_with(@project)
  end

end
