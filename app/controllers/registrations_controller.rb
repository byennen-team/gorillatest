class RegistrationsController < Devise::RegistrationsController
  layout :get_layout

  #def new
  #  # super
  #  #redirect_to root_path, flash: {notice: "If you want to try out AutoTest, please request a beta invite below."}
  #end

  def edit
    if request.parameters.try(:[], "plan") == "maxed" && !current_user.can_create_project?
      flash[:notice] = I18n.t "devise.projects.max_number_reached"
    end
    super
  end

  def cancel_user
    stripe_customer = current_user.create_or_retrieve_stripe_customer
    stripe_customer.subscriptions.retrieve(current_user.stripe_subscription_token).delete()
    user = current_user
    user.destroy
    Rails.logger.debug("user is destroyed")
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    # current_user.destroy
    redirect_to "/"
  end

  def change_plan

  end

  protected

  def after_sign_up_path_for(resource)
    projects_path
    #company_path(current_user.company)
  end

  def get_layout
    return 'session' unless %w(edit upgrade change_plan).include?(params[:action])
    return 'application'
  end

end
