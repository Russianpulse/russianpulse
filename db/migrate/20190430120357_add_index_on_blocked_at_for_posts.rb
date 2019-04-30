class AddIndexOnBlockedAtForPosts < ActiveRecord::Migration[5.1]
  def change
    add_index :posts, :blocked_at
  end
end
