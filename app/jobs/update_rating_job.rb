class UpdateRatingJob < ActiveJob::Base
  queue_as :default

  def perform
    EventTracker.track "Jobs", "Rating update"

    Blog.find_each do |blog|
      blog.update_attribute :rating, blog.posts.sum(:views)
    end
  end
end
