class UpdateRatingJob < ApplicationJob
  queue_as :default

  def perform
    EventTracker.track 'Jobs', 'Rating update'

    Blog.find_each do |blog|
      blog.update_column :rating, rating(blog)
    end
  end

  private

  def rating(blog)
    return 0 if count(blog) == 0

    (views(blog) + comments(blog) * Post::COMMENTS_POWER)
  end

  def count(blog)
    blog.posts.count
  end

  def views(blog)
    blog.posts.sum(:views)
  end

  def comments(blog)
    blog.posts.sum(:comments_count)
  end
end
