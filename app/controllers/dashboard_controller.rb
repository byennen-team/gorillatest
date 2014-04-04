class DashboardController < ApplicationController

  before_filter :authenticate_user!

  def index
    @projects = current_user.projects
    #Rails.logger.debug("user is #{current_user.inspect}")
    #Rails.logger.debug("current company is #{current_company.inspect}")
    #Rails.logger.debug("current company projects are #{current_company.projects.size}")
  end

end
