class InvitationsController < Devise::InvitationsController

  before_filter :authenticate_user!, except: [:edit, :update]

  def create
    project_id = params[:user][:project_id] ? params[:user].delete(:project_id) : nil
    unless @invited_user = User.where(email: params[:user][:email]).first
      resource_class.invite!(invite_params, current_inviter) do |u|
        u.skip_invitation = true
        @invited_user = u
      end
      if project_id && @invited_user.errors.empty?
        @invited_user.send_project_invitation(current_user.id, project_id)
        ProjectUser.create({user_id: @invited_user.id, project_id: project_id, rights: 'member'})
      else
        @invited_user.send_invitation(current_user.id) if !project_id && @invited_user.errors.empty?
      end
    else
      if project_id && !Project.find(project_id).users.include?(@invited_user)
        ProjectUser.create({user_id: @invited_user.id, project_id: project_id, rights: 'member'})
        @invited_user.send_project_invitation(current_user.id, project_id)
      end
    end
    respond_to do |format|
      format.html { redirect_to request.env["HTTP_REFERER"], notice: "Your invitation to #{@invited_user.email} has been sent."}
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

  protected
  # modifying source code to use actionmailer
  # def invite_resource
  #   project_id = params[:user][:project_id] ? params[:user].delete(:project_id) : nil
  #   unless @invited_user = User.where(email: params[:user][:email])
  #     resource_class.invite!(invite_params, current_inviter) do |u|
  #       u.skip_invitation = true
  #       @invited_user = u
  #     end
  #     if project_id && @invited_users.errors.empty?
  #       @invited_user.send_project_invitation(current_user.id, project_id)
  #       ProjectUser.create({user_id: @invited_user.id, project_id: project_id, rights: 'member'})
  #     else
  #       @invited_user.send_invitation(current_user.id) if !project_id && @invited_user.errors.empty?
  #     end
  #   else
  #     if project_id && !Project.find(project_id).users.include?(@invited_user)
  #       ProjectUser.create({user_id: @invited_user.id, project_id: project_id, rights: 'member'})
  #       @invited_user.send_project_invitation(current_user.id, project_id)
  #     end
  #   end
  # end

  private

  def invitation_params
    params.require(:user).permit(:company_name, :phone, :password, :password_confirmation,
                                 :invitation_token, :first_name, :last_name, :location)
  end

  def after_invite_path_for(resource)
    request.env["HTTP_REFERER"]
  end

  def after_accept_path_for(resource)
    projects_path
  end
end
