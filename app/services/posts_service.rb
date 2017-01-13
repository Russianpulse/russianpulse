class PostsService
  def self.featured
    ids = Blog.where(featured: true).map do |b|
      b.posts.order('created_at DESC').pluck(:id).first
    end

    Post.where(id: ids)
  end
end
