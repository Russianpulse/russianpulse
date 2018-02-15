class Posts::AdsCell < BaseCell
  def show
    @post = Post.where(stream: Post::STREAM_PARTNERS).where('created_at > ?', 7.days.ago).recent.first

    render if @post.present?
  end
end
