# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Plan.find_or_create_by(name: "Free", seconds_available: 3600, num_projects: 2,
                       concurrent_browsers: 2, num_users: 1, price: 0)
Plan.find_or_create_by(name: "Starter", seconds_avaialable: 7200, num_projects: 3,
                       concurrent_browsers: 4, num_users: 2, price: 12.00, )
Plan.find_or_create_by(name: "Pro", seconds_available: 21600, num_projects: 10,
                       concurrent_browsers: 5, num_users: 5, price: 37.00)
Plan.find_or_create_by(name: "Team", seconds_available: 50400, num_projects:  50,
                        concurrent_browsers: 15, num_users: 999, price: 68.00)

Coupon.find_or_create_by(code: "BETAUNLIMITED", to_plan: Plan.where(name: "Unlimited").first)
