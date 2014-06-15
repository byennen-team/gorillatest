class PagesController < ApplicationController
  layout 'pages'
  def welcome
    @beta_invitation = BetaInvitation.new
    if user_signed_in?
      redirect_to dashboard_path
    end
  end

  def pricing
    @plans = Plan.all
  end
end
