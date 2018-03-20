class Blogs::PostsController < ApplicationController
  include Pundit
  before_action :set_blogs_post, only: [:show, :edit, :update, :destroy]

  # GET /blogs/posts
  def index
    @blogs_posts = policy_scope Post.limit(10)
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
    @blogs_post = Blogs::Post.new(blogs_post_params)

    if @blogs_post.save
      redirect_to @blogs_post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /blogs/posts/1
  def update
    if @blogs_post.update(blogs_post_params)
      redirect_to @blogs_post, notice: 'Post was successfully updated.'
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
    def set_blogs_post
      @blogs_post = Blogs::Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def blogs_post_params
      params.fetch(:blogs_post, {})
    end
end
