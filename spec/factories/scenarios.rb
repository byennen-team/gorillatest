# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :scenario do
    sequence(:name) {|n| "Scenario #{n}"}
    window_x 1024
    window_y 768
    start_url "http://factor75-autotest.herokuapp.com"
  end
end
