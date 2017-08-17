class CommentsController < ApplicationController
  include ApplicationHelper
  include PostsHelper
  include CommentsHelper
  before_action :set_comment, only: %i[show edit update destroy spam]

  # already protected with captcha
  skip_before_action :verify_authenticity_token, only: :create

  # GET /comments
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  def show; end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  def spam
    if current_user.admin?
      @comment.update_attributes(spam: true)
      @comment.user.update_attributes(flagged: true)
    end

    redirect_to smart_post_path(@comment.commentable), notice: 'Comment marked as SPAM.'
  end

  # GET /comments/1/edit
  def edit; end

  # POST /comments
  def create
    @post = Post.find params[:post_id]

    # FIXME: what if user_params are blank?
    @user = User.find_or_initialize_by user_params

    @user.password = SecureRandom.hex if @user.new_record?

    @comment = @post.comments.new(comment_params.merge(user: @user))

    if verify_recaptcha
      flag_spammer

      if @user.save && @comment.save
        ga_event category: :comments, action: :create, label: @post.title, interaction: 1, value: 1

        EventTracker.notify 'comments', 'create', <<-MSG
        #{@user.name}:
        #{@comment.comment}
        #{@post.title} #{(begin
                            comment_url(@comment)
                          rescue
                            :cant_get_comment_url
                          end)}
        MSG

        begin
          sign_in @user
        rescue
          nil
        end

        @user.follow(@post) if params[:subscribe] == '1'

        notify_post_subscribers

        redirect_to comment_path(@comment), notice: t('comments.thank_you')
      else
        redirect_to smart_post_path(@post)
      end

    else
      redirect_to smart_post_path(@post), error: t('security.robot_atack')
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
    if Comment.exists?(comment: @comment.comment, user: @comment.user)
      @comment.user.update_attributes! flagged: true
    end
  end
end
