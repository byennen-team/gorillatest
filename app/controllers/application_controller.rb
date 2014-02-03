class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_company

  #before_filter :http_basic_authenticate, if: :staging?
  before_filter :update_sanitized_params, if: :devise_controller?

  def current_company
    @current_company = current_user.company
  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email, :password, :password_confirmation, :company_name, :phone, :first_name, :last_name, :location)}
    devise_parameter_sanitizer.for(:accept_invitation) {|u| u.permit(:email, :password, :password_confirmation, :company_name, :phone, :invitation_token)}
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || dashboard_path
  end

  before_filter :allow_cross_domain_access
  def allow_cross_domain_access
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def staging?
    Rails.env.staging?
  end

  def http_basic_authenticate
    Rails.logger.debug("Authenticating w/ HTTP Basic")
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["STAGING_USERNAME"] && password == ENV["STAGING_PASSWORD"]
    end
  end

end
