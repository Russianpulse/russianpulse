source 'https://rubygems.org'

gem 'puma', '~> 3.0'
gem 'rails', '~> 5.0'

gem 'rails_admin'

# Assets & JS & CSS
gem 'bootstrap-sass'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'js_cookie_rails'
gem 'rails-assets-bootstrap-material-design'
gem 'sass-rails', '~> 5.0'
gem 'therubyracer', platforms: :ruby
gem 'uglifier'

gem 'acts_as_commentable'
gem 'acts_as_follower'
gem 'acts_as_votable', '~> 0.12.0'
gem 'cells-erb'
gem 'cells-rails'
gem 'devise'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem 'dotenv-rails'
gem 'ejs'
gem 'erubis'
gem 'fastimage'
gem 'feedjira'
gem 'fog-aws'
gem 'gon'
gem 'httpclient'
gem 'kaminari'
gem 'kaminari-i18n'
gem 'liquid'
gem 'mime-types'
gem 'nokogiri', '1.8.2'
gem 'pundit'
gem 'rack-attack'
gem 'redcarpet'
gem 'ruby-readability', require: 'readability'
gem 'ruby-stemmer', require: 'lingua/stemmer'
gem 'russian'
gem 'sentry-raven'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'simple_form'
gem 'sitemap_generator'
gem 'staccato'
gem 'typogruby'
gem 'webpacker'

# Dataabses
gem 'pg'
gem 'sqlite3'

group :production do
  gem 'dalli'
  gem 'newrelic_rpm'
  gem 'rails_12factor'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  gem 'bundler-audit'
  gem 'listen', '~> 3.0.5'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'bullet'
  gem 'faker'
  # gem 'guard-livereload'
  gem 'letter_opener'
  gem 'rack-livereload'
  gem 'rb-readline'
  gem 'rubocop'
end

group :development, :test do
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'rspec_junit_formatter', '0.2.2'
  # gem 'benchmark-ips'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'vcr'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'webmock'

  # TODO: remove it
  gem 'rails-controller-testing'
  gem 'simplecov', require: false
end

gem 'sdoc', '~> 0.4.0', group: :doc

gem 'flag-icons-rails'
gem 'font-awesome-rails'

# TODO: remove it
source 'https://rails-assets.org' do
  gem 'rails-assets-backbone'
  gem 'rails-assets-jquery-ui'
  gem 'rails-assets-underscore'
end
