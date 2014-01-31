class RecorderController < ApplicationController

  layout 'recorder'

  before_filter :find_project_and_company
  # after_filter :allow_iframe
  # This is going to need to do some stuff but for now
  # I just want it as a placeholder - jkr
  def index
    response.headers.delete "X-Frame-Options"
    render
  end

  private

  def find_project_and_company
    @project = Project.find(params[:project_id])
    @company = @project.company
  end

end
