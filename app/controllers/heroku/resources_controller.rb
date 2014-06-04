class Heroku::ResourcesController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :authenticate

  def create
    @user = User.new_for_heroku(params[:resource])
    if @user.save
      response = {id: @user.id.to_s}
      HerokuWorker.perform_async("fetch_project", @user.id.to_s)
      render json: response
    else
      Rails.logger.debug("What the hell is giong on?")
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    render json: "ok"
  end

  def update
    @user = User.find(params[:id])
    response = {
      :id => @user.id,
      :message => 'Successfully Updated Plan'
    }
    render json: response
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "gorillatest" &&
        password == "d1079df84eb12770c6d068b778024553"
    end
  end

end
