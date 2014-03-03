# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Plan.find_or_create_by(name: "Free", seconds_available: 3600, price: 0)
Plan.find_or_create_by(name: "Unlimited", seconds_available: Plan::UNLIMITED_MINUTES, price: 0)

Coupon.find_or_create_by(code: "BETAUNLIMITED", to_plan: Plan.where(name: "Unlimited").first)
