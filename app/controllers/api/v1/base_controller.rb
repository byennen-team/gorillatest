class Api::V1::BaseController < ApplicationController

  protect_from_forgery with: :null_session

  skip_before_filter :http_basic_authenticate

  before_filter :restrict_access

  helper_method :current_company

  def current_company
    @current_company
  end

  def restrict_access
    Rails.logger.debug("Authenticating via token")
    authenticate_or_request_with_http_token do |token, options|
      Rails.logger.debug("token is #{token}")
      @current_company = Company.find_by(api_key: token)
    end
  end

end
