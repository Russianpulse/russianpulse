source 'https://rubygems.org'

gem 'rails', '4.2.6'

# Assets & JS & CSS
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'js_cookie_rails'

gem 'ruby-readability', :require => 'readability'
gem 'actionpack-action_caching'
gem 'acts_as_commentable'
gem 'cells', '~> 4.0.0'
gem 'cells-erb'
gem 'devise', '~> 3.5.4'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem 'ejs'
gem 'fastimage'
gem 'feedjira'
gem 'httpclient'
gem 'pg'
gem 'puma'
gem 'pundit'
gem 'rails_admin'
gem 'redcarpet'
gem 'ruby-stemmer', :require => 'lingua/stemmer'
gem 'russian'
gem 'session_off'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'simple_form'
gem 'sitemap_generator'
gem 'staccato'
gem 'typogruby'

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
  gem 'simplecov', require: false
end

gem 'sdoc', '~> 0.4.0', group: :doc
