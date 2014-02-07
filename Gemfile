source 'http://rubygems.org'

ruby '2.0.0'
gem 'rails', '4.0.2'
gem 'thin'
gem 'mongoid', git: 'git://github.com/mongoid/mongoid.git'
gem 'mongoid-paranoia', github: 'simi/mongoid-paranoia'

gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass'
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
gem 'google-analytics-rails'

# Devise
gem 'devise'
gem 'cancan'

# invitation
gem 'devise_invitable'

# serializers
gem 'active_model_serializers'

# sidekiq
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', :require => nil


# selenium
gem 'selenium-webdriver'

#heroku platform gem
group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'thin'
  gem "quiet_assets", "~> 1.0.1"
  gem "better_errors", "~> 0.2.0"
  gem 'binding_of_caller'
  gem 'pry'
  gem 'pry-rails'
  gem 'letter_opener'
end

group :test do
  gem 'rspec-rails'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'factory_girl_rails'
end

group :development, :test do
  gem 'jasmine'
  gem 'mongoid-rspec'
  gem 'guard'
  gem 'guard-rspec'
  gem 'shoulda-matchers'
end
