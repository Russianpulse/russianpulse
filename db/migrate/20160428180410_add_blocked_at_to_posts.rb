class AddBlockedAtToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :blocked_at, :datetime
  end
end
