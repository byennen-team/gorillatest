class AutotestController < ApplicationController

  layout 'test'

	def index; end

	def form
    @project_id = params[:project_id]
  end

	def form_post
    if params[:name].blank?
      flash.now[:error] = "Please fill out your name"
      render 'form', location: test_form_path(project_id: params[:project_id])
    else
  	  redirect_to test_thankyou_path(project_id: params[:project_id])
    end
	end

  def thankyou; end

end
