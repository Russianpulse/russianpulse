class CommentPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def upvote?
    true
  end

  def downvote?
    true
  end
end
