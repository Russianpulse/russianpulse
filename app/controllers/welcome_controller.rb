class WelcomeController < ApplicationController
  def index
    ids = []

    @posts_top = posts_top.where.not(id: ids).limit(3)
    ids += @posts_top.pluck(:id)

    @posts_most_discussed = Post.published.where.not(id: ids).most_discussed.newer_than(1.week.ago).limit(6)
    ids += @posts_most_discussed.pluck(:id)

    @posts_featured = Post.published.where('blogs.featured = ?', true).joins(:blog).where.not('posts.id IN (?)', ids).joins(:blog).recent.limit(6)
    ids += @posts_featured.pluck(:id)

    @posts_recent = stream_scope.where.not(id: ids).recent.limit(30)
    ids += @posts_recent.pluck(:id)
  end

  private

  def stream_scope
    scope = Post.published

    scope = scope.where(stream: params[:stream]) if params[:stream].present?

    scope
  end

  def posts_top
    if params[:stream].present?
      stream_scope.with_picture.recent
    else
      Post.published.top.with_picture.recent
    end
  end
end