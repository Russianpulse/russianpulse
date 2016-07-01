class UpdatePostsPerHourJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Blog.find_each do |blog|
      posts_per_hour = blog.posts.newer_than(1.week.ago).count.to_f / (7 * 24).to_f
      blog.update_column :posts_per_hour, posts_per_hour
    end
  end
end
