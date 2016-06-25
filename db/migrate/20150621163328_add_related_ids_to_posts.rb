class AddRelatedIdsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :related_ids, :text
  end
end
