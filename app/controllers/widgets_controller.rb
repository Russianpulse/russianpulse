class WidgetsController < ApplicationController
  include ActionView::Helpers::OutputSafetyHelper
  include ApplicationHelper
  include PostsHelper

  session :off

  def index
    @post = Post.last
  end

  def post
    @post = Post.find_by slug_id: params[:slug_id]
    @post ||= Post.find_by id: params[:slug_id]

    render :layout  => false
  end

  def recent
    posts = if params[:featured].present?
              Blog.where(featured: true).map do |b|
                b.posts.order("created_at DESC").first
              end
            else
              Post.published.order("created_at DESC").limit(30)
            end

    render :json  => (params[:callback] || "callback") + "(" + posts_data(posts).to_json + ");"
  end

  def popular
    posts = Post.published.newer_than(2.weeks.ago).order("views DESC").limit(30)
    render :json  => (params[:callback] || "callback") + "(" + posts_data(posts).to_json + ");"
  end

  private

  def posts_data(posts)
    data = posts.map do |p|
      {
        id: p.id,
        title: typography(p.title),
        blog_id: p.blog_id,
        link: smart_post_url(p),
        favicon: favicon_url(p.source_url),
      }
    end
  end
end
