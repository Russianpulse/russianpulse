class BlogsController < ApplicationController
  MAX_PER_PAGE = 20

  def index
    @blogs = Blog.popular
  end

  def show
    @blog = Blog.find_by!(slug: params[:slug])

    unless request.path == URI(blog_path(@blog.slug, format: params[:format])).path
      redirect_to blog_path(@blog.slug, format: params[:format])
      return
    end

    @posts = @blog.posts.published.recent

    if time_limit.present?
      @posts = @posts.where('posts.created_at > ?', time_limit.ago)
    end

    respond_to do |format|
      format.html do
        @posts = @posts.page(params[:page])
      end
      format.atom do
        @posts = @posts.limit(MAX_PER_PAGE)
      end
    end

    fresh_when last_modified: [@posts.maximum(:updated_at), @blog.updated_at].compact.max, public: true
    expires_in 5.minutes, public: true
  end

  private

  def time_limit
    Rails.cache.fetch "blogs_controller:#{@blog.id}:#{@blog.updated_at}:time_limit", expires_in: 1.day do
      @blog.duration_having_posts(MAX_PER_PAGE * 10) || 1.month
    end
  end
end
