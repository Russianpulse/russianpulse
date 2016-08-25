class PingerJob < ApplicationJob
  queue_as :default

  include Rails.application.routes.url_helpers
  include PostsHelper

  def perform(post)
    Pinger.ping post.title, smart_post_url(post)
  end
end
