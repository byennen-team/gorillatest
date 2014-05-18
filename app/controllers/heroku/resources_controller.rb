class Heroku::ResourcesController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :authenticate

  def create
    @user = User.new_for_heroku(params[:resource])
    if @user.save
      Rails.logger.debug("\n\n\n\n\n\n\n\nuser is #{@user.id}")
      # Schedule project creation through worker
      response = {id: @user.id.to_s}
      render json: response
    else
      Rails.logger.debug(@user.errors.inspect)
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
      Rails.logger.debug("username is #{username}")
      Rails.logger.debug("password is #{password}")
      username == "gorilla_test" &&
        password == "d1079df84eb12770c6d068b778024553"
    end
  end

end
