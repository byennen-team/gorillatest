class AutotestController < ApplicationController

  layout 'test'

  before_filter :find_project

  skip_before_filter :http_basic_authenticate

	def index; end

	def form
    @project_id = params[:project_id]
  end

	def form_post
    flash.now[:error] = ""
    if params[:name].blank?
      flash.now[:error] += "Please fill out your name. "
    end
    if params[:password] != params[:password_confirmation]
      flash.now[:error] += "Your passwords do not match."
    end

    if flash.now[:error].blank?
      session[:autotest_signup] = params
      redirect_to test_thankyou_path(project_id: params[:project_id])
    else
      render 'form', location: test_form_path(project_id: params[:project_id])
    end
	end

  def thankyou; end

  def terms; end

  private

    def find_project
      @project = Project.find(params[:project_id])
    end


end
