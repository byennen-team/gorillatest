class BetaInvitationsController < ApplicationController
  layout 'welcome'

  def create
    @beta_invitation = BetaInvitation.new(beta_invitation_params)
    if @beta_invitation.save
      redirect_to root_path, notice: 'Beta invitation was successfully created.'
    else
      redirect_to root_path, error: 'Beta invitation was not sent.'
    end
  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
  def beta_invitation_params
    params.require(:beta_invitation).permit(:first_name, :last_name, :company, :email)
  end
end
