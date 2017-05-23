class AddPostIdsToTags < ActiveRecord::Migration[4.2]
  def change
    add_column :tags, :post_ids, :text
  end
end
