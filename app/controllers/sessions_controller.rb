class SessionsController < Devise::SessionsController
  layout 'session'

  protected

  def after_sign_up_path_for(resource)
    dashboard_path
  end

end
