class AddIndeciesToPosts < ActiveRecord::Migration[4.2]
  def change
    add_index :posts, :created_at
    add_index :posts, :views
  end
end
