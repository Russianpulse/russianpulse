class RefreshSitemapJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    EventTracker.notify :sitemap, :started
    SitemapGenerator::Interpreter.run(config_file: nil, verbose: false)
    SitemapGenerator::Sitemap.ping_search_engines
    EventTracker.track_and_notify :sitemap, :refresh
  rescue StandardError => e
    EventTracker.notify :sitemap, :failed, e.to_s

    raise e
  end
end
