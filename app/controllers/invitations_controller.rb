class InvitationsController < Devise::InvitationsController

  def create
    super
  end

  def edit
    super
  end

  protected
  # modifying source code to use actionmailer
  def invite_resource
    resource_class.invite!(invite_params, current_inviter) do |u|
      u.skip_invitation = true
      @invited_user = u
    end
    User.send_invitation(@invited_user) if @invited_user.errors.empty?
    @invited_user
  end

  private
def
   after_invite_path_for(resource)
    flash[:success] = "Invitation successfully sent!"
    new_invitation_path
  end
end
