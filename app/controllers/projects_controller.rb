class ProjectsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_project, except: [:index, :new, :create]
  before_filter :get_concurrency_limit, only: [:index, :show]
  before_filter :ensure_num_projects_limit, only: [:create]

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
    if @project.notifications.any?
      @notification = @project.notifications.first
    else
      @notification = @project.notifications.build
    end
  end

  def update
    @project.attributes = project_params
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
    if @project.notifications.any?
      @notification = @project.notifications.first
    else
      @notification = @project.notifications.build
    end

    if notification_params.values.reject(&:empty?).length == 0
      @notification.destroy
      notice = {notice: "Settings saved"}
    else
      @notification.attributes = notification_params
      notice = @notification.save ? {notice: "Notification Settings successfully saved"} : {alert: "Notification settings cannot be saved"}
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

    if status == 200
      UserMailer.script_verification(current_user.email, @project.id.to_s).deliver
    end

    respond_to do |format|
      format.js {render json: {message: flash[:notice]}.to_json, status: status}
      format.html {redirect_to :back}
    end
  end

  def run
    test_run = @project.test_runs.build({user: current_user, platforms: params[:browsers], queued_at: Time.now})
    if test_run.save
      test_run.platforms.each do |p|
        browser_test = test_run.browser_tests.create!({browser: p.split('_').last,
                                              platform: p.split('_').first})
      end
      TestWorker.perform_async("queue_tests", "Project", test_run.id.to_s)
      respond_to do |format|
        format.html { redirect_to project_test_run_path(@project, test_run) }
        format.json { }
      end
    end
  end

  private

  def ensure_num_projects_limit
    if current_user.owned_projects.count >= current_user.plan.num_projects
      redirect_to :back, notice: "You have reached the max number of projects you can create. Upgrade your plan to get more projects."
    end
  end

  def project_params
    params.require(:project).permit(:name, :url, :basic_auth_username, :basic_auth_password)
  end

  def notification_params
    params.require(:notification).permit(:subdomain, :room_name, :token, :service)
  end
end
