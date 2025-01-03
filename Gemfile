source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
gem 'dotenv-rails', groups: [:development, :test]

ruby '3.3.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
# javascript
gem 'jsbundling-rails'
# css bundling
gem 'cssbundling-rails'
# stimulus
gem 'stimulus-rails'
# styling
gem "tailwindcss-rails"
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'jquery-rails'
gem 'pry'
gem 'simple_form'
# gem 'google-api-client', github: 'googleapis/google-api-ruby-client'
gem 'awesome_print'
gem 'hirb'
gem 'httparty'
gem 'sendgrid-ruby'
gem 'turbo-rails'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Ruby 3.1.0 fix
gem 'net-smtp', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
