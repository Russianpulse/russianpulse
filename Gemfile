source 'https://rubygems.org'

gem 'rails', '~> 5.0'
gem 'puma', '~> 3.0'

gem 'rails_admin', '~> 1.0'

# Assets & JS & CSS
gem 'sass-rails', '~> 5.0'
gem 'uglifier'
gem 'coffee-rails', '~> 4.2'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'
gem 'bootstrap-sass'
gem 'js_cookie_rails'
gem 'turbolinks', '~> 5.0.0'

gem 'acts_as_commentable'
gem 'acts_as_follower'
gem 'cells-rails'
gem 'cells-erb'
gem 'devise'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem 'ejs'
gem 'exception_notification'
gem 'fastimage'
gem 'feedjira'
gem 'gon'
gem 'httpclient'
gem 'liquid'
gem 'pg'
gem 'pundit'
gem 'redcarpet'
gem 'ruby-readability', require: 'readability'
gem 'ruby-stemmer', require: 'lingua/stemmer'
gem 'russian'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'simple_form'
gem 'sitemap_generator'
gem 'slack-notifier'
gem 'staccato'
gem 'typogruby'
gem 'dotenv-rails'
gem 'fog'
gem 'asset_sync'

gem 'nokogiri', '~> 1.7.1'
gem 'erubis'

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

  gem 'listen', '~> 3.0.5'
  gem 'bundler-audit'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'

  gem 'letter_opener'
  gem 'letter_opener_web', '~> 1.2.0'
  gem 'rack-livereload'
  gem 'guard-livereload'
  gem 'rb-readline'
  gem 'rubocop'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'rspec_junit_formatter', '0.2.2'
  gem 'rack-mini-profiler', require: false
  # gem 'benchmark-ips'
  gem 'bullet'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'vcr'
end

group :test do
  gem 'webmock'
  gem 'capybara'

  # TODO: remove it
  gem 'rails-controller-testing'
end

gem 'sdoc', '~> 0.4.0', group: :doc

gem 'font-awesome-rails'

source 'https://rails-assets.org' do
  gem 'rails-assets-jquery-ui'
  gem 'rails-assets-underscore'
  gem 'rails-assets-backbone'
  gem 'rails-assets-jquery-timeago'
end
