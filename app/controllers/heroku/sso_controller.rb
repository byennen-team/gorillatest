class Heroku::SsoController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :authenticated, :request_valid

  def create
    cookies["heroku-nav-data"] = params['nav-data']
    session[:heroku_sso] = true
    #session[:current_account_id] = @account.id
    if sign_in(@user)
      Rails.logger.debug("We should redirect")
      redirect_to dashboard_url
    else
      Rails.logger.debug("for some reason we are here")
      render status: 404, text: "404 Not Found"
    end
  end

  protected

  def authenticated
    @user = User.find(params[:id])
  end

  def request_valid
    render status: :forbidden, text: "403 Forbidden" unless token_valid? && timestamp_valid?
  end

  def token_valid?
   pre_token = params[:id] + ':' + '9f8d532591dd8e4574664818d6533325' + ':' + params[:timestamp]
   token = Digest::SHA1.hexdigest(pre_token).to_s
   token == params[:token]
  end

  def timestamp_valid?
    params[:timestamp].to_i >= (Time.now - 2*60).to_i
  end
end
