class PagesController < ApplicationController
  layout 'pages'

  before_filter :initalize_beta_invite

  def welcome
    if user_signed_in?
      redirect_to dashboard_path
    end
  end

  def pricing
    @plans = Plan.all
  end

  private

  def initalize_beta_invite
    @beta_invitation = BetaInvitation.new
  end
end
