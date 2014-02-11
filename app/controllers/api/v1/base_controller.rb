class Api::V1::BaseController < ApplicationController

  helper_method :current_company

  #protect_from_forgery with: :null_session

  skip_before_filter :http_basic_authenticate
  skip_before_filter  :verify_authenticity_token

  before_filter :check_preflight
  before_filter :restrict_access

  after_filter :set_access_control_headers

  def current_project
    @current_project
  end

  def preflight
    preflight = request.method == 'OPTIONS' ? false : true
    return preflight
  end

  def check_preflight
    Rails.logger.debug(request.format)
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = "*"
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

  def restrict_access
    Rails.logger.debug("Authenticating via token")
    authenticate_or_request_with_http_token do |token, options|
      Rails.logger.debug("token is #{token}")
      @current_project = Project.find_by(api_key: token)
    end
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = "#{current_project.base_url}, https://autotest-staging.herokuapp.com, http://staging.autotest.io"
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

end
