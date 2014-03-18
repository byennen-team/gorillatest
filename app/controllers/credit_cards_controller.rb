class CreditCardsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_or_new_credit_card

  def create
    @credit_card.stripe_token = params[:stripe_token]
    if @credit_card.save
      respond_to do |format|
        format.html { redirect_to billing_path }
      end
    end
  end

  def destroy
    begin
      @credit_card.destroy
      flash[:notice] = "Credit Card was deleted"
    rescue Exception => e
      flash[:alert] = "Credit Card Could not be deleted"
    end
    respond_to do |format|
      format.html { redirect_to billing_path }
    end
  end

  private

  def find_or_new_credit_card
    @credit_card = params[:id] ? current_user.credit_cards.find(params[:id]) :
                                 current_user.credit_cards.new
  end
end
