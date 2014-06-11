class PagesController < ApplicationController
  layout 'welcome'
  def welcome
    @beta_invitation = BetaInvitation.new
    if user_signed_in?
      redirect_to dashboard_path
    end
  end
end
