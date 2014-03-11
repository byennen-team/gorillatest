class RegistrationsController < Devise::RegistrationsController
  layout :get_layout

  #def new
  #  # super
  #  #redirect_to root_path, flash: {notice: "If you want to try out AutoTest, please request a beta invite below."}
  #end

  def edit
    super
  end

  def upgrade
    @plan = Plan.find(params[:plan_id])
    Rails.logger.debug("Plan is #{@plan.inspect}")
    if request.post?
      Rails.logger.debug("current user credit card is #{current_user.credit_card.inspect}")
      unless current_user.credit_card
        credit_card = current_user.create_credit_card({stripe_token: params[:stripe_token]})
      end
      current_user.subscribe_to(@plan)
    else

    end
  end

  protected

  def after_sign_up_path_for(resource)
    projects_path
    #company_path(current_user.company)
  end

  def get_layout
    return 'session' unless %w(edit upgrade).include?(params[:action])
    return 'application'
  end

end
