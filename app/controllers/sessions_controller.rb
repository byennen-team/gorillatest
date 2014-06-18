class SessionsController < Devise::SessionsController
  layout 'pages'

  after_filter :remove_heroku_session, only: [:create]
  before_filter :initalize_beta_invite

  protected

  def after_sign_up_path_for(resource)
    dashboard_path
  end

  def remove_heroku_session
    session[:heroku_sso] = false
  end

  def initalize_beta_invite
    @beta_invitation = BetaInvitation.new
  end

end
