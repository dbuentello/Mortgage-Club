source 'https://rubygems.org'

ruby '2.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2'
# Use PostgreSQL as the database for Active Record
gem 'pg'

# A set of responders modules to dry up your Rails 4.2+ app.
# gem 'responders'

# Flexible authentication solution for Rails with Warden
gem 'devise', '~> 3.5'
# Minimal authorization through OO design and pure Ruby classes
gem 'pundit'
# Role management library with resource scoping
gem 'rolify'

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

# Parse CSS and add vendor prefixes to rules by Can I Use
gem 'autoprefixer-rails', '~> 5.2.1.1'

gem 'react-rails', '~> 1.0'

gem 'httparty'

gem 'rest-client'

gem 'nokogiri'

# file attachment management for ActiveRecord
gem 'paperclip'

# official AWS SDK for Ruby
gem 'aws-sdk', '< 2'

# Load environment variables
gem 'dotenv-rails'

# A Better Nested Inheritable Layouts
gem 'nestive'

# A wrapper gem for the DocuSign REST API
gem 'docusign_rest', github: 'hoang1417/docusign_rest', branch: 'master'

# A wrapper gem for Stripe REST API
gem 'stripe'
# gem 'omniauth-stripe-connect'

# Pretty print your Ruby objects with style
gem 'awesome_print'

# ActiveRecord backend integration for DelayedJob 3.0+
gem 'delayed_job_active_record'

# A Frontend for Delayed Job
# gem 'delayed_job_web'

gem 'daemons'

# dealing with money and currency conversion.
gem 'money'

# A library for financial calculations in Ruby
gem 'finance'

# A Ruby client library for Redis
gem 'redis'

# communicating with the Twilio API and generating TwiML
gem 'twilio-ruby', '~> 4.2.1'

# A Ruby wrapper for the Nexmo API
gem 'nexmo'

# performance management system, available at http://localhost:4000/newrelic
gem 'newrelic_rpm'

gem 'asposecloud'

# to crawl data from Zillow
gem 'poltergeist'

group :development do
  # just run bundle exec erd
  gem 'rails-erd'

  # help to kill N+1 queries and unused eager loading
  gem 'bullet'
  # Profiler for your development and production Ruby rack apps.
  gem 'rack-mini-profiler', require: false

  # A very fast & simple Ruby web server
  gem 'thin'
end

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

  # A library for generating fake data such as names, addresses, and phone numbers.
  gem 'faker'

  # A library for setting up Ruby objects as test data
  gem 'factory_girl_rails'

  # Add a comment summarizing the current schema
  # annotate --exclude tests,fixtures,factories,serializers : model only
  gem 'annotate', '~> 2.6.6'

  gem 'rubocop'
  # Use Capistrano for deployment
  # gem 'capistrano-rails', group: :development
end

group :test do
  # cleans out database before running tests to ensure clean slate for testing
  gem 'database_cleaner'

  # Acceptance test framework for web applications
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'cucumber_factory'
  gem 'spreewald'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'guard-rspec'
  gem 'timecop'
end

group :production do
  # Makes running your Rails app easier. Based on the ideas behind 12factor.net
  gem 'rails_12factor'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby
end
