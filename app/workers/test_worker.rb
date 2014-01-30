class TestWorker

  include Sidekiq::Worker

  sidekiq_options :retry => false, :backtrace => true

  def perform(test_run_id, current_user_id)
    TestRun.find(test_run_id).run(current_user_id)
  end

end
