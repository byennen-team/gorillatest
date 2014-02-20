class Api::V1::ProjectsController < Api::V1::BaseController

  respond_to :json, :js

  skip_before_filter :restrict_access

  def index
    @projects = [@current_project]
    respond_with(@projects)
  end

  def show
    @project = current_project
    respond_with(@project)
  end

  def play
    @project = Project.where({api_key: params[:api_key]})
    test_run = @project.test_runs.build({user: current_user, platforms: params[:browsers]})
    if test_run.save
      test_run.platforms.each do |p|
        browser_test = test_run.browser_tests.create!({browser: p.split('_').last,
                                              platform: p.split('_').first})
      end
      TestWorker.perform_async("queue_tests", "Project", test_run.id.to_s)
    end
    respond_with("OK")
  end

end
