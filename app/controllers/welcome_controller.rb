class WelcomeController < ApplicationController
  layout 'welcome'
  def index
    @beta_invitation = BetaInvitation.new
    if user_signed_in?
      redirect_to dashboard_path
    end
  end
end
