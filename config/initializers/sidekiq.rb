Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/12' }

  config.on(:startup) do
    Sidekiq.schedule = YAML
      .load_file(File.expand_path('../../../config/scheduler.yml', __FILE__))
    Sidekiq::Scheduler.reload_schedule!
  end

end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/12' }
end


