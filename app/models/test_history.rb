class TestHistory

  include Mongoid::Document
  include Mongoid::Timestamps

  # test_run_id, test_run_type => Feature # 1
  embedded_in :test_runnable, polymorphic: true

  embeds_many :history_line_items

end