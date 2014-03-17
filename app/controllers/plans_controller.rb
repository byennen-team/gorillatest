class PlansController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_plan

  def upgrade
    if request.post?
      begin
        unless current_user.credit_card
          credit_card = current_user.create_credit_card({stripe_token: params[:stripe_token]})
        end
        if current_user.subscribe_to(@plan)
          respond_to do |format|
            format.html { redirect_to change_plan_path }
            format.js { render text: "success"}
          end
        end
      rescue Exception => e
        flash[:alert] = "Your card could not be processed"
        respond_to do |format|
          format.js { render text: "Your card could not be processed", status: 402}
          format.html {}
        end
      end
    end
  end

  def downgrade
    if current_user.can_downgrade?(@plan) && current_user.subscribe_to(@plan)
      respond_to do |format|
        format.html { redirect_to change_plan_path }
      end
    end
  end

  private

    def find_plan
      @plan = Plan.find(params[:id])
    end

end
