class AddRelatedIdsToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :related_ids, :text
  end
end
