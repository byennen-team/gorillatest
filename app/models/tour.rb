class Tour
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  belongs_to :user

  field :dashboard, type: Boolean, default: false
  field :sample_project, type: Boolean, default: false
  field :test_run, type: Boolean, default: false
  field :test_runs_index, type: Boolean, default: false
  field :project, type: Boolean, default: false
  field :dashboard, type: Boolean, default: false

end
