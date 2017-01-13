require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'newrelic_rpm'

module Mazavr
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = ENV['TIMEZONE'] || 'Moscow'

    config.autoload_paths += %W(#{Rails.root}/app/services)
    config.autoload_paths += %W(#{Rails.root}/app/workers)
    config.autoload_paths += %W(#{Rails.root}/app/decorators)

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]

    config.x.domain = ENV['DOMAIN_NAME']
    config.x.archive_sign_salt = ENV['ARCHIVE_SIGN_SALT'] || 'abc123'

    config.x.cleanup_posts_limit = (ENV['CLEANUP_POSTS_LIMIT'] || 8000).to_i

    ENV['CACHE_REVALIDATE_SECRET_COOKIE'] ||= 'wEYfgbwfhg8239FBwhejFNO4fbg8ebfkwgbg'

    config.cache_store = :dalli_store,
                         'memcached',
                         { username: nil,
                           password: nil,
                           failover: true,
                           socket_timeout: 1.5,
                           socket_failure_delay: 0.2,
                           race_condition_ttl: 5 }

    # Use a real queuing backend for Active Job (and separate queues per environment)
    config.active_job.queue_adapter = :sidekiq
    # config.active_job.queue_name_prefix = "mazavr_#{Rails.env}"
  end
end
