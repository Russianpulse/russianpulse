class Posts::CommentsLinkCell < BaseCell
  def show
    @post = Post.find model
    render
  end
end
