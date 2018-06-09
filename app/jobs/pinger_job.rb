# Not used for now
class PingerJob < ApplicationJob
  queue_as :default

  include Rails.application.routes.url_helpers
  include UriHelper
  include PostsHelper

  def perform(post)
    Pinger.ping post.title, smart_post_url(post)
  end

  protected

  def default_url_options 
    Rails.configuration.action_controller.default_url_options
  end
end
