class InvitationsController < Devise::InvitationsController

  before_filter :authenticate_user!, except: [:edit, :update]
  before_filter :split_emails, :ensure_user_can_invite_to_project, only: [:create]
  before_filter :resource_from_invitation_token, only: [:edit, :update]

  def create
    project_id = params[:project_id].blank? ? nil : params[:project_id]
    @emails.each do |email|
      invited_user = User.where(email: email).first
      if !invited_user
        resource_class.invite!({email: email}, current_inviter) do |u|
          invited_user = u
          u.skip_invitation = true
          u.skip_confirmation!
          u.confirm!
          u.invitation_sent_at = Time.now
          u.save(validate: false)
        end
        if project_id
          ProjectUser.create({user_id: invited_user.id, project_id: project_id, rights: 'member'})
          invited_user.send_project_invitation_new_user(current_user.id, project_id)
        else
          UserMailer.send_invitation_email(invited_user.id.to_s).deliver
        end
      else
        if project_id && !Project.find(project_id).users.include?(invited_user)
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
    session[:invitation_token] ||= @invitation_token
    super
  end

  def update
    resource.assign_attributes(invitation_params)
    if resource.save
      resource.invited_by.messages.create({message: "#{resource.name} has accepted your invitation", url: "javascript:void(0)"})
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message :notice, flash_message
      sign_in(resource_name, resource)
      resource.send_welcome_email
      respond_with resource, :location => after_accept_path_for(resource)
    else
      respond_with_navigational(resource){ render :edit }
    end
  end

  private

  def resource_from_invitation_token
    @invitation_token = params[:invitation_token] || params[:user][:invitation_token]
    unless @invitation_token && self.resource = resource_class.where(invitation_token: @invitation_token).first
      set_flash_message(:alert, :invitation_token_invalid)
      redirect_to after_sign_out_path_for(resource_name)
    end
  end


  def split_emails
    @emails = params[:user][:email].split(",")
  end

  def ensure_user_can_invite_to_project
    if !params[:project_id].blank?
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
