class InvitationsController < Devise::InvitationsController

  before_filter :authenticate_user!, except: [:edit, :update]
  before_filter :split_emails, :ensure_user_can_invite_to_project, only: [:create]

  def create
    project_id = params[:project_id]
    @emails.each do |email|
      invited_user = User.where(email: email).first
      if !invited_user
        resource_class.invite!({email: email}, current_inviter) do |u|
          invited_user = u
          invited_user.skip_invitation = true
          invited_user.skip_confirmation!
          invited_user.confirm!
          invited_user.save(validate: false)
        end
        ProjectUser.create({user_id: invited_user.id, project_id: project_id, rights: 'member'})
        invited_user.send_project_invitation_new_user(current_user.id, project_id)
      else
        if !Project.find(project_id).users.include?(invited_user)
          ProjectUser.create({user_id: invited_user.id, project_id: project_id, rights: 'member'})
          invited_user.send_project_invitation_existing_user(current_user.id, project_id)
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to request.env["HTTP_REFERER"], notice: "Your invitations have been sent."}
    end
  end

  def edit
    session[:invitation_token] ||= params[:invitation_token]
    super
  end

  def update
    update_resource_params = invitation_params
    super
  end

  private

  def split_emails
    @emails = params[:user][:email].split(",")
  end

  def ensure_user_can_invite_to_project
    if params[:project_id]
      @project = Project.find(params[:project_id])
      if @project.creator.plan.num_users < @project.users.count + @emails.length
        flash[:notice] = "Invitations were not sent because you only have #{@project.num_invitations_remaining} invites remaining for this project! Upgrade your plan to invite more users."
        redirect_to :back
      end
    end
  end

  def invitation_params
    params.require(:user).permit(:company_name, :phone, :password, :password_confirmation,
                                 :invitation_token, :first_name, :last_name, :location, :uid, :provider)
  end

  def after_invite_path_for(resource)
    request.env["HTTP_REFERER"]
  end

  def after_accept_path_for(resource)
    projects_path
  end
end
