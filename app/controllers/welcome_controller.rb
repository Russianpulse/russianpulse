class WelcomeController < ApplicationController
  def index
    ids = []

    @posts_top = posts_top.where.not(id: ids).limit(3)
    ids += @posts_top.pluck(:id)

    @posts_featured = posts_scope.where('blogs.featured = ?', true).joins(:blog).where.not('posts.id IN (?)', ids).joins(:blog).recent.limit(6)
    ids += @posts_featured.pluck(:id)

    @posts_recent = posts_scope.where.not(id: ids).recent.limit(30)
    ids += @posts_recent.pluck(:id)
  end

  private

  def posts_scope
    scope = Post.published.where.not(stream: Post::STREAM_PARTNERS)


    scope = scope.where(stream: params[:stream]) if params[:stream].present?

    scope
  end

  def posts_top
    if params[:stream].present?
      posts_scope.with_picture.recent
    else
      posts_scope.top.with_picture.recent
    end
  end
end
