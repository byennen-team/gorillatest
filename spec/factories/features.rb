# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feature do
    sequence(:name) {|n| "Feature #{n}"}
  end
end
