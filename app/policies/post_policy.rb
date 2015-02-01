# Post access policy
class PostPolicy < ApplicationPolicy
  # Posts scope policy
  class Scope < Scope
    def resolve
      scope
    end
  end
end
