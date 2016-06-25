class AddPostIdsToTags < ActiveRecord::Migration
  def change
    add_column :tags, :post_ids, :text
  end
end
