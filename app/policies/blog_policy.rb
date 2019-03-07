class BlogPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope if user.admin?

      scope.where(id: allowed_blogs)
    end

    private

    def allowed_blogs
      Blog.joins(:authors).where(blogs_users: { user_id: user.id })
    end
  end
end
