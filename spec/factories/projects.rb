# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    sequence(:name) {|n| "Project #{n}"}
    url "http://factor75.com"
  end
end
