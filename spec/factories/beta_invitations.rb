# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :beta_invitation do
    first_name "MyString"
    last_name "MyString"
    company "MyString"
    email "MyString"
  end
end
