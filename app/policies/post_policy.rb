# Post access policy
class PostPolicy < ApplicationPolicy
  # Posts scope policy
  class Scope < Scope
    def resolve
      if user.admin?
        scope
      else
        scope.where(user_id: user)
      end
    end
  end

  def update?
    user.admin?
  end

  def dashboard?
    update?
  end
end
