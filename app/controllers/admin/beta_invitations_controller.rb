class Admin::BetaInvitationsController < Admin::ApplicationController
  load_and_authorize_resource :beta_invitation

  def index
    @beta_invitations = BetaInvitation.all
  end
end
