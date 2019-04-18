module VotesHelper
  def upvote_button_class(item)
    'btn-info' if signed_in? && current_user.voted_up_on?(item)
  end

  def downvote_button_class(item)
    'btn-info' if signed_in? && current_user.voted_down_on?(item)
  end
end
