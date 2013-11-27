class DashboardController < ApplicationController
  def index
    Rails.logger.debug("user is #{current_user.inspect}")
    Rails.logger.debug("current company is #{current_company.inspect}")
    Rails.logger.debug("current company projects are #{current_company.projects.size}")
  end
end
