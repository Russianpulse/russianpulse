class FindRelatedPostsJob < ActiveJob::Base
  queue_as :default

  def perform(post)
    post.update_attribute :related_ids, post.find_related.pluck(:id)
  end
end
