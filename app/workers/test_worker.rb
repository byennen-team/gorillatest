class TestWorker

  include Sidekiq::Worker

  sidekiq_options :retry => false, :backtrace => true
  
  def perform(test_run_id)
    TestRun.find(test_run_id).run
  end

end
