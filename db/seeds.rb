# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts "Create Plans"
Plan.delete_all
Plan.find_or_create_by(name: "Free", seconds_available: 3600, num_projects: 2,
                       concurrent_browsers: 2, num_users: 1, price: 0, stripe_id: "free",
                       developer_mode: false, import_selenium_scripts: false, test_scheduling: false,
                       deploy_process: false, popular: false, plan_style: "panel-success")

Plan.find_or_create_by(name: "Starter", seconds_available: 7200, num_projects: 3,
                       concurrent_browsers: 4, num_users: 2, price: 12.00, stripe_id: "starter",
                       developer_mode: false, import_selenium_scripts: false, test_scheduling: false,
                       deploy_process: false, popular: false, plan_style: "panel-teal")

Plan.find_or_create_by(name: "Pro", seconds_available: 21600, num_projects: 10,
                       concurrent_browsers: 5, num_users: 5, price: 37.00, stripe_id: "pro",
                       developer_mode: false, import_selenium_scripts: true, test_scheduling: true,
                       deploy_process: true, popular: true, plan_style: "panel-primary")

Plan.find_or_create_by(name: "Team", seconds_available: 50400, num_projects:  50,
                        concurrent_browsers: 15, num_users: 999, price: 68.00, stripe_id: "team",
                        developer_mode: true, import_selenium_scripts: true, test_scheduling: true,
                        deploy_process: true, popular: false, plan_style: "panel-darken")

puts "Create Coupon Code"
Coupon.find_or_create_by(code: "BETAUNLIMITED", to_plan: Plan.where(name: "Starter").first)
