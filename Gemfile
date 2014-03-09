source 'http://rubygems.org'

ruby '2.1.1'
gem 'rails', '4.0.3'
gem 'thin'
gem 'mongoid', git: 'git://github.com/mongoid/mongoid.git'
gem 'mongoid-paranoia', github: 'simi/mongoid-paranoia'

gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass'
gem 'bourbon'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'haml-rails'
gem 'simple_form'
gem 'font-awesome-rails'
gem 'figaro'
gem 'pusher'
gem 'fog'
gem 'unf'
gem 'google-analytics-rails'
gem 'crack'
gem 'tinder'
gem 'mail_view'
gem 'mongoid_slug'

# Devise
gem 'devise'
gem 'cancancan', '~> 1.7.0'
gem 'rolify', git: 'git://github.com/EppO/rolify.git'

# Alternative login
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-github'

# invitation
gem 'devise_invitable'

# serializers
gem 'active_model_serializers'

# sidekiq
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', :require => nil

# selenium
gem 'selenium-webdriver'

gem 'httparty'

# money
gem 'money-rails', git: 'https://github.com/RubyMoney/money-rails.git', ref: 'c0bf5ef27b55938933c189a5324a810028ff3303'

#heroku platform gem
group :production do
  gem 'rails_12factor'
end

group :development do
  gem "quiet_assets", "~> 1.0.1"
  gem "better_errors", "~> 0.2.0"
  gem 'binding_of_caller'
  gem 'pry'
  gem 'pry-rails'
  gem 'letter_opener'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'jasmine'
  gem 'mongoid-rspec'
  gem 'guard'
  gem 'guard-rspec'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'fuubar'
  gem 'mocha'
end
