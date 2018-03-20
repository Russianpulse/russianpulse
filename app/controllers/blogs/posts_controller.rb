class Blogs::PostsController < ApplicationController
  include Pundit
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  helper_method :blogs


  # GET /blogs/posts
  def index
    @blogs_posts = policy_scope Post.recent.limit(100)
  end

  # GET /blogs/posts/1
  def show
  end

  # GET /blogs/posts/new
  def new
    @post = Post.new
  end

  # GET /blogs/posts/1/edit
  def edit
  end

  # POST /blogs/posts
  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to action: :show, id: @post.id, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /blogs/posts/1
  def update
    if @post.update(post_params)
      redirect_to action: :show, id: @post.id, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /blogs/posts/1
  def destroy
    @blogs_post.destroy
    redirect_to blogs_posts_url, notice: 'Post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:blog_id, :title, :body).merge(user_id: current_user.id)
    end

    def blogs
      policy_scope Blog.all
    end
end
