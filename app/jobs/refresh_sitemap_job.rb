class RefreshSitemapJob < ActiveJob::Base
  queue_as :default

  def perform(*_args)
    EventTracker.notify :sitemap, :started
    SitemapGenerator::Interpreter.run(config_file: nil, verbose: false)
    SitemapGenerator::Sitemap.ping_search_engines
    EventTracker.track_and_notify :sitemap, :refresh

  rescue StandardError => ex
    EventTracker.notify :sitemap, :failed, ex.to_s

    raise ex
  end
end
