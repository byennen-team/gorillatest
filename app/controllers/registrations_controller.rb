class RegistrationsController < Devise::RegistrationsController
  def new
    flash[:notice] = "Please fill in the rest of the form to finish signing up." if session["devise.user_attributes"]
    super
  end

  def edit
    super
  end

  def update
    @user = User.find(current_user.id)
    if password_change?
      success = @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      success = @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update).except(:current_password,:password,:password_confirmation))
    end

    if success
      set_flash_message :notice, :updated
      sign_in @user, bypass: true if password_change?
      redirect_to my_info_path
    else
      render "edit"
    end
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
    if params[:plan] == "maxed"
      flash.now[:alert] = "You have reached your plan limit. Upgrade your plan to create more projects!"
    end
  end

  def manage_billing; end

  protected

  def after_sign_up_path_for(resource)
    dashboard_path
  end

  def after_update_path_for(resource)
    my_info_path
  end

  def password_change?
    !params[:user][:current_password].blank? && !params[:user][:password].blank?
  end
end
