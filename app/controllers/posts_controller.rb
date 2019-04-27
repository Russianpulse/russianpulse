class PostsController < ApplicationController
  include ApplicationHelper
  include PostsHelper

  def index
    @posts = Post.published.recent.includes(:blog).limit(20)

    @posts = @posts.top if params[:top] == '1'
    @posts = @posts.page params[:page]

    respond_to do |format|
      format.html
      format.atom
    end

    fresh_when @posts
    expires_in 5.minutes, public: true
  end

  def most_discussed
    @post = Post.find params[:id]

    render html: cell('most_discussed', @post)
  end

  def show
    @post = find_post_by_slug_or_id(params[:slug_id], (params[:id] || params[:slug_id]).to_i)

    if @post.blank?
      raise ActiveRecord::RecordNotFound if params[:slug_id].blank?

      @slug_id = params[:slug_id]
      redirect_to goto_path(url: "https://goo.gl/#{@slug_id}")

    elsif request.path == URI(smart_post_path(@post)).path
      render template: 'posts/show_blocked' if @post.blocked?
      fresh_when(@post, public: true) if guest?
    else
      redirect_to smart_post_path(@post)
    end
  end

  def counter
    views = Post.where(id: params[:id]).pluck(:views).first
    Post.where(id: params[:id]).update_all accessed_at: Time.now.in_time_zone, views: views.to_i + 1

    redirect_to '/counter.png', protocol: request.ssl? ? 'https://' : 'http://'
  end

  def block
    post = Post.find params[:id]

    redirect_to smart_post_path(post)

    authorize post, :update?
    post.update_attribute :stream, :trash
  end

  private

  def find_post_by_slug_or_id(slug, id)
    post = if slug.present?
             Post.find_by(slug_id: slug) || Post.find_by(id: id)
           else
             Post.find_by(id: id)
           end

    post
  end
end
