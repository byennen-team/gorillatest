class HerokuWorker

  include SIdekiq::Worker

  def perform(method, *args)
    self.send(method, *args)
  end

  def fetch_project(user_id)
    @user = User.find(user_id)
    @user.create_heroku_project
  end
