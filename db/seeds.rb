# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Plan.create(name: "Free", seconds_available: 3600, price: 0)
Plan.create(name: "Unlimited", seconds_available: Plan::UNLIMITED_MINUTES, price: 0)

