class CompaniesController < ApplicationController

  def show
    @projects = @company.projects
  end

  def dashboard
    @projects = @company.projects
  end

  private

  def find_company
    # This may go away, we can derive the company from 
    # the user logged in
    @company = Company.find(params[:id])
  end

end
