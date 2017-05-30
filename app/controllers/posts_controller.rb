class PostsController < ApplicationController
  include ApplicationHelper
  include PostsHelper

  def index
    @posts = Post.published.recent.includes(:blog).limit(20)

    @posts = @posts.older_than(Time.at(params[:before].to_f)) if params[:before].present?

    @posts = @posts.top if params[:top] == '1'

    respond_to do |format|
      format.html
      format.atom
    end
  end

  def show
    @post = find_post_by_slug_or_id(params[:slug_id], (params[:id] || params[:slug_id]).to_i)

    if @post.blank?
      raise ActiveRecord::RecordNotFound if params[:slug_id].blank?

      @slug_id = params[:slug_id]
      redirect_to goto_path(url: "http://goo.gl/#{@slug_id}")

      expires_in(1.hour, public: true)
    else
      if request.path == URI(smart_post_path(@post)).path
        if @post.blocked?
          render template: 'posts/show_blocked'
        else
          render template: 'posts/show'
        end
      else
        redirect_to smart_post_path(@post)
      end
    end
  end

  def counter
    views = Post.where(id: params[:id]).pluck(:views).first
    Post.where(id: params[:id]).update_all accessed_at: Time.now, views: views.to_i + 1

    redirect_to '/counter.png', protocol: request.ssl? ? 'https://' : 'http://'
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
