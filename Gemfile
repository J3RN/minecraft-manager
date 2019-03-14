source 'https://rubygems.org'

ruby '2.4.2'

gem 'rails', '4.2.10'
gem 'pg', '~> 0.18'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

# Perform jobs (starting/stopping phoenixes) in the background
gem 'sidekiq', '~> 5.0'

# Sinatra for Sidekiq dashboard
gem 'sinatra', require: false

# DigitalOcean API gem <3
gem 'droplet_kit', '~> 2.8'

# Haml templating language
gem 'haml-rails', '~> 1.0'

# Canned styles
gem 'bootstrap-sass'

# User account management
gem 'devise', '~> 4.3'

# Application server
gem 'passenger'

# Secrets management
gem 'dotenv-rails'

group :development, :test do
  gem 'awesome_print'
  gem 'byebug'
end

group :development do
  gem 'spring'
  gem 'web-console'
end

group :test do
  gem 'factory_girl_rails', '~> 4.5'
  gem 'rspec-rails', '~> 3.0'
end

group :development do
  # Capistrano for deploys
  gem 'capistrano', '~> 3.9'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
end
