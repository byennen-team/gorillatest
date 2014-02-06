class RegistrationsController < Devise::RegistrationsController

  def edit
    super
  end

  protected

  def after_sign_up_path_for(resource)
    projects_path
    #company_path(current_user.company)
  end

end
