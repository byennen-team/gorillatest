FactoryGirl.define do
  factory :testing_allowance do
    seconds_used 3600
    start_at Time.now.beginning_of_month
  end
end
