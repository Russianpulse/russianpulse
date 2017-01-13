class RefreshSitemapJob < ActiveJob::Base
  queue_as :default

  def perform(*_args)
    SitemapGenerator::Interpreter.run(config_file: nil, verbose: false)
    SitemapGenerator::Sitemap.ping_search_engines
    EventTracker.track_and_notify :sitemap, :refresh
  end
end
