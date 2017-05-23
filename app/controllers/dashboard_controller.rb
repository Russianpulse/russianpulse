class DashboardController < ApplicationController
  def index
    authorize Post, :dashboard?

    gon.push(posts: {
               trash: stream_as_json(:trash),
               inbox: stream_as_json(:inbox),
               pulse: stream_as_json(:pulse)
             })
  end

  def stream_count
    count = Post.where(stream: params[:stream]).count

    respond_to do |format|
      format.json { render json: { count: count } }
    end
  end

  def update_post
    @post = Post.find params[:id]
    authorize @post, :dashboard?
    @post.update_attribute :stream, params[:post][:stream]

    respond_to do |format|
      format.json { render json: @post }
    end
  end

  private

  def stream_as_json(stream)
    posts = Post.select(:id, :title, :created_at, :blog_id, :top, :comments_count, :picture_url)
    posts = posts.includes(:blog).recent.where(stream: stream).limit(50)

    posts.as_json(methods: %i[blog_title has_picture?])
  end
end
