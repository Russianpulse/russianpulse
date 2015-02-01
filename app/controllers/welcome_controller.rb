class WelcomeController < ApplicationController
  caches_action :index, expires_in: 5.minutes

  def index
    ids = []

    @posts_recent = Post.published.recent.limit(30)
    ids += @posts_recent.pluck(:id)

    @posts_most_discussed = Post.published.where.not(id: ids).most_discussed.newer_than(1.week.ago).limit(6)
    ids += @posts_most_discussed.pluck(:id)

    @posts_featured = Post.published.joins(:blog).where("blogs.featured = ?", true).where.not("posts.id IN (?)", ids).joins(:blog).recent.limit(6)
    ids += @posts_featured.pluck(:id)

    @posts_top = Post.published.top.with_picture.where.not(id: ids).recent.limit(3)
    ids += @posts_top.pluck(:id)

    @full_header = true
    expires_in(5.minutes, public: true)
  end
end
