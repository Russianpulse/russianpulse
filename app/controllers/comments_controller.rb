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

  # POST /comments
  def create
    @post = Post.find params[:post_id]
    @comment = @post.comments.new(comment_params.merge(user: current_user))

    flag_spammer

    if !verify_recaptcha
      redirect_to smart_post_path(@post), error: t('security.robot_atack')
    elsif cooldown_spammer?(current_user)
      redirect_to smart_post_path(@post), error: t('security.spammer_atack')
    else

      if @comment.save
        ga_event category: :comments, action: :create, label: @post.title, interaction: 1, value: 1

        EventTracker.notify 'comments', 'create', <<-MSG
        #{current_user.name}:
        #{@comment.comment}
        #{@post.title} #{(begin
                            comment_url(@comment)
                          rescue StandardError
                            :cant_get_comment_url
                          end)}
        MSG

        current_user.follow(@post) if params[:subscribe] == '1'

        notify_post_subscribers

        redirect_to comment_path(@comment), notice: t('comments.thank_you')
      else
        redirect_to smart_post_path(@post)
      end
    end
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

  def cooldown_spammer?(user)
    return unless user.persisted?
    return unless user.flagged?

    key = "cooldown:user:#{user.id}"

    if Rails.cache.exist? key
      true
    else
      Rails.cache.write key, expires_in: 5.minutes + rand(15).minutes

      false
    end
  end
end
