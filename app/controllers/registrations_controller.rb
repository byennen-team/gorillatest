class RegistrationsController < Devise::RegistrationsController
  layout 'session'

  #def new
  #  # super
  #  #redirect_to root_path, flash: {notice: "If you want to try out AutoTest, please request a beta invite below."}
  #end

  def edit
    super
  end

  def upgrade
    @plan = Plan.find(params[:plan_id])
    if request.post?
      if current_user.credit_card
        current_user.upgrade_plan(plan)
      # Just update the plan
      else
        # create the credit card and stuff
      end
    else

    end
  end

  protected

  def after_sign_up_path_for(resource)
    projects_path
    #company_path(current_user.company)
  end

end
