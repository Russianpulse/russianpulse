module Posts
  # Vertical widget with 3 posts
  class TripleCell < BaseCell
    def show
      posts = model
      @post1 = posts.find(&:has_picture?) || posts.first

      @post2, @post3 = posts.reject { |p| p == @post1 }
                            .sort_by(&:created_at)
                            .reverse

      render
    end
  end
end
