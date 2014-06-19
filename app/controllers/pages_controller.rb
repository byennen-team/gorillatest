class PagesController < ApplicationController
  layout 'pages'

  def welcome
    if user_signed_in?
      redirect_to dashboard_path
    end
  end

  def pricing
    @plans = Plan.all
  end

  def beta_invitation
    @beta_invitation = BetaInvitation.new
  end

  def create_beta_invitation
    @beta_invitation = BetaInvitation.new(beta_invitation_params)
    if @beta_invitation.save
      redirect_to root_path, notice: 'Beta invitation was successfully created.'
    else
      redirect_to beta_invitation_path, alert: 'Beta invitation was not sent.'
    end
  end


  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def beta_invitation_params
    params.require(:beta_invitation).permit(:first_name, :last_name, :company, :email)
  end

end
