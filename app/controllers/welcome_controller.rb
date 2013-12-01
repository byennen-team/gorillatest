class WelcomeController < ApplicationController
  layout 'welcome'
  def index
    @beta_invitation = BetaInvitation.new
  end
end
