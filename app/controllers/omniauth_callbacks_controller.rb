class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"], (session[:invitation_token] || nil) )
    @user.skip_confirmation!
    if @user.save
      @user.confirm! unless @user.sign_in_count > 0
      if @user.invited_by_id
        @user.invited_by.messages.create({message: "#{@user.name} has accepted your invitation", url: "javascript:void(0)"})
      end
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
      sign_in_and_redirect @user
    else
      flash.notice = "Oops, we encountered a problem. Please try again."
      if @user.invited_by_id
        redirect_to accept_invitation_url(invitation_token: session[:invitation_token])
      else
        redirect_to new_user_registration_url
      end
    end
  end

  def github
    @user = User.from_omniauth(request.env["omniauth.auth"], (session[:invitation_token] || nil) )
    @user.skip_confirmation!

    if @user.save
      @user.confirm! unless @user.sign_in_count > 0
      if @user.invited_by_id
        @user.invited_by.messages.create({message: "#{@user.name} has accepted your invitation", url: "javascript:void(0)"})
      end
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Github"
      sign_in_and_redirect @user
    else
      flash.notice = "Oops, we encountered a problem. Please try again."
      if @user.invited_by_id
        redirect_to accept_invitation_url(invitation_token: session[:invitation_token])
      else
        redirect_to new_user_registration_url
      end
    end
  end

end
