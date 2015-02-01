class AddBlockedAtToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :blocked_at, :datetime
  end
end
