class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_omniauth(request.env["omniauth.auth"], (session[:invitation_token] || nil))
    if user.save
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      flash.notice = "You are almost Done! Please provide a password to finish setting up your account"
      if !user.invitation_token.blank?
        redirect_to accept_invitation_url(invitation_token: session[:invitation_token])
      else
        redirect_to new_user_registration_url(user)
      end
    end
  end
end
