FactoryGirl.define do
  factory :testing_allowance do
    seconds_used 0
    start_at Time.now.beginning_of_month
  end
end
