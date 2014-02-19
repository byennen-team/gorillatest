FactoryGirl.define do
  factory :scenario_browser_test do
    browser "firefox"
    platform "linux"
  end

  factory :project_browser_test do
    browser "firefox"
    platform "linux"
  end
end
