class ProjectsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_project, except: [:index, :new, :create]
  before_filter :get_concurrency_limit, only: [:index, :show]
  before_filter :ensure_num_projects_limit, only: [:create]

  def index
    @projects = current_user.projects
  end

  def show
    @scenarios = @project.scenarios.all.sort_by(&:created_at).reverse
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
    if @project.save
      @project_user = ProjectUser.create!({user_id: current_user.id, project_id: @project.id, rights: 'owner'})
      respond_to do |format|
        format.html { redirect_to project_path(@project) }
      end
    else
      respond_to do |format|
        format.html { render :new, alert: "Project could not be created." }
      end
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
        format.html { redirect_to dashboard_path }
      end
    end
  end

  def add_owner
    new_owner = User.find(params[:user_id])
    if new_owner.can_create_project?
      pu = ProjectUser.find_by(project_id: @project.id, user_id: new_owner.id)
      pu.update_attribute(:rights, "owner")
      flash[:notice] = "Successfully added #{new_owner.name} as owner"
    else
      flash[:alert] = "#{new_owner.name} has reached their plan limit and cannot be added as an owner"
    end
    redirect_to edit_project_path(@project, anchor: "users")
  end

  def remove_owner
    remove_owner = User.find(params[:user_id])
    pu = ProjectUser.find_by(project_id: @project.id, user_id: remove_owner.id)
    pu.update_attribute(:rights, "member")
    redirect_to edit_project_path(@project, anchor: "users"), notice: "#{remove_owner.name} is now a regular member of the project"
  end

  def destroy
    if @project.destroy
      respond_to do |format|
        format.html { redirect_to dashboard_path }
      end
    end
  end

  def remove_user
    @user = User.find(params[:user_id])
    @project_user = ProjectUser.where(project_id: @project.id, user_id: @user.id)
    if @project_user.destroy
      respond_to do |format|
        format.html { redirect_to edit_project_path(@project, anchor: "users") }
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
    attr_changed = false
    begin
      if @project.script_present?
        attr_changed = true if @project.script_verified == false
        @project.update_attribute(:script_verified, true)
        flash[:notice] = "Script has been successfully verified"
        status = 200
      else
        flash[:notice] = "Could not verify the script at #{@project.url}."
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

    if status == 200 && attr_changed
      UserMailer.script_verification(current_user.email, @project.id.to_s).deliver
    end

    respond_to do |format|
      format.js {render json: {message: flash[:notice]}, status: status}
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
