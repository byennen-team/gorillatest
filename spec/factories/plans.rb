# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan do
    name "Free"
    price 0
    seconds_available 3600
    num_users 1
    num_projects 2
    concurrent_browsers 2
    stripe_id "free"
  end
  factory :starter_plan, parent: :plan do
    name "Starter"
    seconds_available 7200
    num_projects 3
    concurrent_browsers 4
    num_users 2
    price 12.00
    stripe_id "starter"
  end
end
