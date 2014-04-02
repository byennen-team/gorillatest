class MessagesController < ApplicationController

  def mark_read
    if current_user.messages.update_all({read: true})
      render json: {success: true}, status: 200
      # respond_to do |format|
      #   format.js { render json: {success: true}, status: 200 }
      # end
    else
      Rails.logger.debug("why are you failing")
    end
  end

end
