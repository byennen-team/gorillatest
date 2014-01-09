class Api::BaseController < ApplicationController

  before_filter :current_company

  # Replace this with auth key stuff - jkr
  def current_company
    @current_company = Company.first
  end

end
