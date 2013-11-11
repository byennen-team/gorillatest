class RegistrationsController < Devise::RegistrationsController

  def edit
    super
  end

  protected

  def after_sign_up_path_for(resource)
    company_path(current_user.company)
  end

end
