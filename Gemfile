source 'https://rubygems.org'

ruby '2.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2'
# Use PostgreSQL as the database for Active Record
gem 'pg'

# A set of responders modules to dry up your Rails 4.2+ app.
# gem 'responders'

gem 'devise', '~> 3.5'

# Makes running your Rails app easier. Based on the ideas behind 12factor.net
gem 'rails_12factor'

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'bootstrap-sass', '~> 3.3.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# JavaScript libraries
gem 'jquery-rails'
gem 'lodash-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Rails Html Sanitizer for HTML sanitization
gem 'rails-html-sanitizer'

# Use Unicorn as the app server
gem 'unicorn'

gem 'autoprefixer-rails'

gem 'react-rails', '~> 1.0.0.pre', github: 'reactjs/react-rails'

gem 'httparty'

gem 'nokogiri'

# file attachment management for ActiveRecord
gem 'paperclip'

# official AWS SDK for Ruby
gem 'aws-sdk', '< 2'

# Load environment variables
gem 'dotenv-rails'

# A Better Nested Inheritable Layouts
gem 'nestive'

group :development, :test do
  # Call 'debugger' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exceptions page and /console in development
  gem 'web-console', '~> 2.0.0.beta2'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Manage application processes
  gem 'foreman'

  # testing framework
  gem 'rspec-rails'

  # A library for setting up Ruby objects as test data
  gem 'factory_girl_rails'

  # Use Capistrano for deployment
  # gem 'capistrano-rails', group: :development
end

group :test do
  # A library for generating fake data such as names, addresses, and phone numbers.
  gem 'faker'

  # cleans out database before running tests to ensure clean slate for testing
  gem 'database_cleaner'
end

group :production do
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby
end
