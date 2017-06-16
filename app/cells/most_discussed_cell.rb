class MostDiscussedCell < Cell::ViewModel
  LIMIT = 9

  def show
    @posts = most_discussed_posts
    cell("posts/text_block", @posts)
  end

  def horizontal
    @posts = most_discussed_posts.limit(6)
    render
  end

  private

  def recent_commentable
    Post.where id: Post.recent.where('comments_count > 0').limit(LIMIT * 3).pluck(:id)
  end

  def most_discussed_posts
    recent_commentable.where.not(id: current_post_id).order('comments_count DESC, created_at DESC').limit LIMIT
  end

  def current_post_id
    model.try(:id) || 0
  end
end
