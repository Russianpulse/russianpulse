class CommentsController < ApplicationController
  include ApplicationHelper
  include PostsHelper
  include CommentsHelper
  include Devise::Controllers::Rememberable
  before_action :set_comment, only: %i[show edit update destroy spam upvote downvote]

  # already protected with captcha
  skip_before_action :verify_authenticity_token, only: %i[create upvote downvote]

  # GET /comments
  def index
    @comments = Comment.all
  end

  def recent
    @post = Post.find params[:post_id]
    @comments = Comment.recent.not_for(@post).limit(20)
  end

  def upvote
    if signed_in?
      authorize @comment, :upvote?
      @comment.vote_by voter: current_user, vote: 'up'
    else
      render_js_redirect new_user_session_path
    end
  end

  def downvote
    authorize @comment, :downvote?
    @comment.vote_by voter: current_user, vote: 'down'
  end

  # GET /comments/1
  def show; end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  def spam
    if current_user.admin?
      @comment.update(spam: true)
      @comment.user.update(flagged: true)
    end

    redirect_to smart_post_path(@comment.commentable), notice: 'Comment marked as SPAM.'
  end

  # GET /comments/1/edit
  def edit; end

  include CreateComment

  # POST /comments
  def create
    create_comment
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to @comment, notice: 'Comment was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    redirect_to comments_url, notice: 'Comment was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:comment).permit(:comment)
  end

  def user_params
    (params[:comment] || {}).require(:user_attributes).permit(:name, :email)
  end

  def notify_post_subscribers
    @post.followers.each do |follower|
      next if follower == current_user

      CommentsMailer.created(@comment, follower).deliver_later
    end
  end

  def flag_spammer
    return if @comment.user.new_record?
    return unless Comment.exists?(comment: @comment.comment, user: @comment.user)

    @comment.user.update! flagged: true
  end
end
