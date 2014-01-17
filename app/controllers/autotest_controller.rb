class AutotestController < ApplicationController

    layout 'test'

	def index; end

	def form
    @project_id = params[:project_id]
  end

	def form_post
	  redirect_to test_thankyou_path(project_id: params[:project_id])
	end

  def thankyou; end

end
