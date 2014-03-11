# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan do
    name "Free"
    price 0
    seconds_available 3600
    num_users 1
    num_projects 2
    concurrent_browsers 2
  end
end
