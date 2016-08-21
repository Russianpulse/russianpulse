source 'https://rubygems.org'

gem 'rails', '~> 4.2.7.1'

# Assets & JS & CSS
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'js_cookie_rails'

gem 'acts_as_commentable'
gem 'acts_as_follower'
gem 'cells', '~> 4.0.0'
gem 'cells-erb'
gem 'devise', '~> 3.5.4'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem 'ejs'
gem 'exception_notification'
gem 'fastimage'
gem 'feedjira'
gem 'gon'
gem 'httpclient'
gem 'pg'
gem 'pundit'
gem 'rails_admin'
gem 'redcarpet'
gem 'ruby-readability', :require => 'readability'
gem 'ruby-stemmer', :require => 'lingua/stemmer'
gem 'russian'
gem 'session_off'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'simple_form'
gem 'sitemap_generator'
gem 'slack-notifier'
gem 'staccato'
gem 'typogruby'

group :production do
  gem 'newrelic_rpm'
  gem 'rails_12factor'
  gem 'dalli'
end

group :development do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'spring-commands-rspec'
  gem 'bundler-audit', '0.5.0'
end

group :development, :test do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'rspec_junit_formatter', '0.2.2'
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

gem 'sdoc', '~> 0.4.0', group: :doc

source 'https://rails-assets.org' do
  gem 'rails-assets-jquery-ui'
  gem 'rails-assets-underscore'
  gem 'rails-assets-backbone'
  gem 'rails-assets-jquery-timeago'
end
