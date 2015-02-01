class AddIndeciesToPosts < ActiveRecord::Migration
  def change
    add_index :posts, :created_at
    add_index :posts, :views
  end
end
