class AddIndexOnBlogIdForPosts < ActiveRecord::Migration[5.1]
  def change
    add_index :posts, :blog_id
  end
end
