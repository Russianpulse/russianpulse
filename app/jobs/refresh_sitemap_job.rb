class RefreshSitemapJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    SitemapGenerator::Interpreter.run(config_file: nil, verbose: true)
    SitemapGenerator::Sitemap.ping_search_engines
    EventTracker.track_and_notify :sitemap, :refresh
  end
end
