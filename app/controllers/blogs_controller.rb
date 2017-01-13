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

    @posts = @blog.posts

    @posts = @posts.includes(:blog).order('created_at DESC').limit(12)
    @posts = @posts.older_than(Time.at(params[:before].to_f)) if params[:before].present?

    respond_to do |format|
      format.html
      format.atom
    end

    expires_in(5.minutes, public: true)
  end
end
