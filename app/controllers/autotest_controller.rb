class AutotestController < ApplicationController

  layout 'test'

  before_filter :find_project

  skip_before_filter :http_basic_authenticate

	def index; end

	def form
    @project_id = params[:project_id]
  end

	def form_post
    if params[:name].blank?
      flash.now[:error] = "Please fill out your name"
      render 'form', location: test_form_path(project_id: params[:project_id])
    else
      session[:autotest_signup] = params
  	  redirect_to test_thankyou_path(project_id: params[:project_id])
    end
	end

  def thankyou; end

  private

    def find_project
      @project = Project.find(params[:project_id])
    end


end
