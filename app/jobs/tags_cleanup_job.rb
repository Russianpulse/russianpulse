class TagsCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Tag.find_each do |tag|
      tag.with_lock do
        post_ids = Post.where(id: tag.post_ids).pluck(:id) || []
        removed_ids = (tag.post_ids || []) - post_ids

        tag.update_attribute :post_ids, post_ids

        logger.info "TagsCleanupJob tag##{tag.id} removed: #{removed_ids.size}"
      end
    end
  end
end
