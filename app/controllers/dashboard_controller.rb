class DashboardController < ApplicationController
  def index
    authorize Post, :dashboard?
    posts = Post.select(:id, :title, :created_at, :blog_id, :top, :comments_count).includes(:blog).recent

    gon.push({
      posts: {
        trash: posts.where(stream: :trash).limit(50).as_json(methods: [:blog_title]),
        inbox: posts.where(stream: :inbox).limit(50).as_json(methods: [:blog_title]),
        pulse: posts.where(stream: :pulse).limit(50).as_json(methods: [:blog_title]),
      }
    })
  end

  def update_post
    @post = Post.find params[:id]
    authorize @post, :dashboard?
    @post.update_attribute :stream, params[:post][:stream]

    respond_to do |format|
      format.json { render json: @post }
    end
  end
end
