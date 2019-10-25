module CreateComment
  def create_comment
    @post = Post.find params[:post_id]

    if !verify_recaptcha
      redirect_to smart_post_path(@post), error: t('security.robot_atack')
    else
      sign_in_new_user
      @comment = @post.comments.new(comment_params.merge(user: current_user))

      flag_spammer

      if cooldown_spammer?(current_user)
        redirect_to smart_post_path(@post), error: t('security.spammer_atack')
      elsif @comment.save
        ga_event category: :comments, action: :create, label: @post.title, interaction: 1, value: 1

        EventTracker.notify 'comments', 'create', <<~MSG
          #{current_user.name}:
          #{@comment.comment}
          #{@post.title} #{safe_comment_url(@comment)}
        MSG

        current_user.follow(@post) if params[:subscribe] == '1'

        notify_post_subscribers

        redirect_to comment_path(@comment), notice: t('comments.thank_you')
      else
        redirect_to smart_post_path(@post)
      end
    end
  end

  private

  def safe_comment_url(comment)
    comment_url comment
  rescue StandardError
    :cant_get_comment_url
  end

  def sign_in_new_user
    return if signed_in?

    user = User.find_or_initialize_by(user_params)

    if user.new_record?

      user.password = SecureRandom.hex if user.new_record?
      user.skip_confirmation!
      user.save
    end

    sign_in user
    remember_me user

    user
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
