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

  def create?
    BlogUser.where(user_id: user.id).exists?
  end

  def update?
    return true if user.admin?
    return false if user.id.blank?

    record.user_id == user.id
  end

  def block?
    user.admin?
  end

  def dashboard?
    update?
  end
end
