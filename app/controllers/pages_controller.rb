class PagesController < ApplicationController
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

  def send_developer_emails
    emails = params[:developer][:emails].split(",")
    emails.each do |email|
      if params[:developer][:test_run_id]
        UserMailer.test_run_details_for_developer(current_user.email, email, params[:developer][:type], params[:developer][:test_run_id]).deliver
      else
        UserMailer.test_details_for_developer(current_user.email, email, params[:developer][:test_id]).deliver
      end
    end
    redirect_to :back
  end

  private
  def beta_invitation_params
    params.require(:beta_invitation).permit(:first_name, :last_name, :company, :email)
  end

end
