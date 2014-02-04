class TestWorker

  include Sidekiq::Worker

  sidekiq_options :retry => false, :backtrace => true

  def perform(method, *args)
    self.send(method, *args)
    # TestRun.find(test_run_id)
  end

  def queue_tests(test_run_id)
    TestRun.find(test_run_id).run
  end

  def run_test(test_run_id, test_id)
    TestRun.find(test_run_id).tests.find(test_id).run
  end

end
