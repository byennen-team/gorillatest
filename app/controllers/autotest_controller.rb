class AutotestController < ApplicationController

    layout 'test'

	def index; end

	def form; end

	def form_post
	  redirect_to action: 'thankyou'
	end

  def thankyou; end
  
end
