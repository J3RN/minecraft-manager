source 'https://rubygems.org'

ruby '2.2.8'

gem 'rails', '4.2.3'
gem 'pg', '~> 0.18'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'sidekiq', '~> 3.4'
gem 'droplet_kit', '~> 1.3'
gem 'haml-rails', '~> 0.9'
gem 'bcrypt'
gem 'bootstrap-sass'
gem 'devise'

# Passenger as the server
gem 'passenger'

# Dotenv for sekrets
gem 'dotenv-rails'

# Sinatra for Sidekiq dashboard
gem 'sinatra', require: false

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'rspec-rails', '~> 3.0'
  gem 'awesome_print'
  gem 'factory_girl_rails', '~> 4.5'
end

group :development do
  # Capistrano for deploys
  gem 'capistrano', '~> 3.9'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
end
