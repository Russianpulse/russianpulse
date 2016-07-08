source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
#gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'rails_admin'

gem 'feedjira'
gem 'typogruby'
gem 'redcarpet'
gem "ruby-readability", :require => 'readability'
gem 'russian'
gem 'ruby-stemmer', :require => 'lingua/stemmer'
gem 'staccato'
#gem 'rb-readline'
gem 'session_off'
gem 'httpclient'
gem 'actionpack-action_caching'
gem 'fastimage'
#gem 'jwt'
gem 'ejs'
gem 'sidekiq'
gem 'simple_form'
gem 'acts_as_commentable'
gem 'devise', '~> 3.5.4'
gem 'devise-i18n'
gem 'devise-i18n-views'

gem 'bootstrap-sass', '~> 3.3.6'
gem 'js_cookie_rails'
gem 'sitemap_generator'

gem 'cells', '~> 4.0.0'
gem 'cells-erb'

gem 'pundit'
gem 'puma'

group :production do
  gem 'newrelic_rpm'
  gem 'rails_12factor'
  gem 'dalli'
end

group :development do
  gem 'spring-commands-rspec'
  gem 'brakeman', :require => false
  gem 'rubocop', require: false
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'rack-mini-profiler', require: false
  #gem 'benchmark-ips'
  gem 'bullet'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'vcr'
end

group :test do
  gem 'webmock'
  gem 'capybara'
  gem 'codeclimate-test-reporter', require: nil
end
