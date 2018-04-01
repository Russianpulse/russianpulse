class Posts::ControlsCell < BaseCell
  def show
    @post = Post.find(model)
    render
  end

  private

  def policy(obj)
    Pundit.policy(current_user, obj)
  end
end
