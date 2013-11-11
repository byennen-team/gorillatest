source 'https://rubygems.org'

gem 'rails', '4.0.0'


gem 'sass-rails', '~> 4.0.0'
gem 'haml'
gem 'bootstrap-sass'

gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'

gem 'haml'

# MongoID
gem 'mongoid', git: 'git://github.com/mongoid/mongoid.git'

# Devise
gem 'devise'
gem 'cancan'

group :test do
  gem 'rspec-rails'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'mongoid-rspec'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'


# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :production do
  #heroku platform gem
  gem 'rails_12factor'
  # Use unicorn as the app server
  gem 'unicorn'
end
