class AddPostsCountToBlogs < ActiveRecord::Migration[5.1]
  def change
    add_column :blogs, :posts_count, :integer, default: 0, null: false

    Blog.find_each do |blog|
      blog.update_attribute :posts_count, blog.posts.count
    end
  end
end
