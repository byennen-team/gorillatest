class ConfirmationsController < Devise::ConfirmationsController
  def new
    super
  end

  # POST /resource/confirmation
  def create
    super
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      sign_in resource
      respond_with_navigational{ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
  end

  protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    new_session_path(resource_name) if is_navigational_format?
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if signed_in?
      signed_in_root_path(resource)
    else
      new_session_path(resource_name)
    end
  end
end
