class RegistrationsController < Devise::RegistrationsController
  def new
    redirect_to root_path, flash: {notice: "If you want to try out AutoTest, please request a beta invite below."}
  end

  def edit
    super
  end

  protected

  def after_sign_up_path_for(resource)
    projects_path
    #company_path(current_user.company)
  end

end
