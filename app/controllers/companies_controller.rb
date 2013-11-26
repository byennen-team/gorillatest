class CompaniesController < ApplicationController

  before_filter :find_company

  def show
    if !@company.nil?
      @projects = @company.projects.all
    end
  end

  def dashboard
    if !@company.nil?
      @projects = @company.projects.all
    end
  end

  private

  def find_company
    # This may go away, we can derive the company from
    # the user logged in
    @company = current_user.company
    Rails.logger.debug("Company is #{@company.inspect}")
  end

end
