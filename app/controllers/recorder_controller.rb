class RecorderController < ApplicationController

  layout 'recorder'

  before_filter :find_project
  # after_filter :allow_iframe
  # This is going to need to do some stuff but for now
  # I just want it as a placeholder - jkr
  def index
    response.headers.delete "X-Frame-Options"
    render
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

end
