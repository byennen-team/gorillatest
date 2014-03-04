FactoryGirl.define do
  factory :user do
    sequence(:first_name) {|n| "Auto#{n}"}
    sequence(:last_name) {|n| "Test#{n}"}
    sequence(:company_name) {|n| "Big Astronaut #{n}"}
    location "Denver, CO"
    phone "9999999999"
    sequence(:email) {|n| "email#{n}@bigastronaut.com"}
    password "password"
    password_confirmation "password"
    plan
  end
end
