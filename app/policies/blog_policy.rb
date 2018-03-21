class BlogPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(id: allowed_blogs)
    end

    private

    def allowed_blogs
      Blog.joins(:authors)
    end
  end
end
