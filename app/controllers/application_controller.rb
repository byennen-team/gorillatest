class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_company

  before_filter :update_sanitized_params, if: :devise_controller?

  def current_company
    @current_company = current_user.company
  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email, :password, :password_confirmation, :company_name, :phone)}
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || dashboard_path
  end

end
