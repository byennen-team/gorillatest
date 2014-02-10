class ProjectsController < ApplicationController

  before_filter :find_project, except: [:index, :new, :create]
  before_filter :authenticate_user!

  def index
    @projects = current_user.projects
  end

  def show
    @features = @project.features
  end

  def new; @project = Project.new; end

  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
    if @project.save
      @project_user = ProjectUser.create!({user_id: current_user.id, project_id: @project.id, rights: 'owner'})
      respond_to do |format|
        format.html { redirect_to project_path(@project) }#, notice: "Project successfully created! Please embed the AutoTest script code to your website and verify it to continue"
      end
    else
      Rails.logger.debug(@project.inspect)
    end
  end

  def edit
    if @project.notifications
      @notification = @project.notifications.first
    else
      @notification = @project.notifications.build
    end
  end

  def update
    @project.attributes = params[:project]
    if @project.save
      respond_to do |format|
        format.html { redirect_to projects_path }
      end
    end
  end

  def destroy
    if @project.destroy
      respond_to do |format|
        format.html { redirect_to projects_path }
      end
    end
  end

  def remove_user
    @user = User.find(params[:user_id])
    @project_user = ProjectUser.where(project_id: @project.id, user_id: @user.id)
    if @project_user.destroy
      respond_to do |format|
        format.html { redirect_to edit_project_path(@project) }
      end
    end
  end

  def update_notifications
    @project.update_attribute(:email_notification, params[:project][:email_notification])
    if @project.notifications
      @notification = @project.notifications.first
    else
      @notification = @project.notifications.build
    end

    @notification.attributes = notification_params
    if @notification.save
      notice = {notice: "Notification Settings successfully saved"}
    else
      notice = {alert: "Notification settings cannot be saved"}
    end

    respond_to do |format|
      format.html { redirect_to edit_project_path(@project, anchor: "notifications"), notice }
    end
  end

  # Move more of this to the model so it's easier to test.
  #  After verifying inclusion just update the attribute.
  def verify_script
    status = nil
    begin
      if @project.script_present?
        @project.update_attribute(:script_verified, true)
        flash[:notice] = "Script has been successfully verified"
        status = 200
      else
        flash[:notice] = "Could not find script."
        status = 400
      end
    rescue => e
      if e == SocketError
        flash[:notice] = "Cannot find website. Please make sure project URL is correct."
      else
        flash[:notice] = "Something went wrong."
      end
      status = 400
    end
    respond_to do |format|
      format.js {render json: {message: flash[:notice]}.to_json, status: status}
      format.html {redirect_to :back}
    end
  end

  private

  def find_project
    @project = current_user.projects.find(params[:id] || params[:project_id])
  end

  def project_params
    params.require(:project).permit(:name, :url)
  end

  def notification_params
    params.require(:notification).permit(:subdomain, :room_name, :token, :service)
  end
end
