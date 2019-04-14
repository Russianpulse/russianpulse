class CommentsController < ApplicationController
  include ApplicationHelper
  include PostsHelper
  include CommentsHelper
  include Devise::Controllers::Rememberable
  before_action :set_comment, only: %i[show edit update destroy spam]

  # already protected with captcha
  skip_before_action :verify_authenticity_token, only: :create

  # GET /comments
  def index
    @comments = Comment.all
  end

  def recent
    @post = Post.find params[:post_id]
    @comments = Comment.recent.not_for(@post).limit(20)
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
    @user = User.find_or_initialize_by user_params
    @user.password = SecureRandom.hex if @user.new_record?
    @comment = @post.comments.new(comment_params.merge(user: @user))

    flag_spammer

    if !verify_recaptcha
      redirect_to smart_post_path(@post), error: t('security.robot_atack')
    elsif cooldown_spammer?(@user)
      redirect_to smart_post_path(@post), error: t('security.spammer_atack')
    else

      if @user.save && @comment.save
        ga_event category: :comments, action: :create, label: @post.title, interaction: 1, value: 1

        EventTracker.notify 'comments', 'create', <<-MSG
        #{@user.name}:
        #{@comment.comment}
        #{@post.title} #{(begin
                            comment_url(@comment)
                          rescue StandardError
                            :cant_get_comment_url
                          end)}
        MSG

        begin
          sign_in @user
          remember_me @user
        rescue StandardError
          nil
        end

        @user.follow(@post) if params[:subscribe] == '1'

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
