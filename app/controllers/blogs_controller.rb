class BlogsController < ApplicationController
  def index
    @blogs = Blog.popular
  end

  def show
    @blog = Blog.find_by!(slug: params[:slug])

    unless request.path == URI(blog_path(@blog.slug, format: params[:format])).path
      redirect_to blog_path(@blog.slug, format: params[:format])
      return
    end

    @posts = @blog.posts.published

    @posts = @posts.includes(:blog).order('created_at DESC').limit(12)
    @posts = @posts.page(params[:page])

    respond_to do |format|
      format.html
      format.atom
    end

    fresh_when last_modified: [@posts.maximum(:updated_at), @blog.updated_at].max, public: true
  end
end
