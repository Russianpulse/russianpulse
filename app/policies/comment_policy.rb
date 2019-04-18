class CommentPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def upvote?
    return false if record.user == user

    true
  end

  def downvote?
    return false if record.user == user

    true
  end
end
