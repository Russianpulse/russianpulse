class MostDiscussedCell < Cell::ViewModel
  LIMIT = 9

  def show
    @posts = Post.most_discussed.where(id: recent_commentable_ids)
    cell("posts/text_block", @posts)
  end

  def horizontal
    @posts = Post.most_discussed.where(id: recent_commentable_ids)
    render
  end

  private

  def recent_commentable_ids
    recent_comments.map { |el| el['post_id'] }
  end

  def recent_comments
    Comment.connection.select_all <<-SQL
      SELECT commentable_id AS post_id, COUNT(id) AS count, MAX(created_at) as created_at FROM comments
        WHERE commentable_id NOT IN (#{model.try(:id) || 0})
        GROUP BY commentable_id
        ORDER BY created_at DESC
        LIMIT #{LIMIT}
    SQL
  end
end
