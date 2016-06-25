class MakePostIdsNullableForTags < ActiveRecord::Migration
  def change
    change_column :tags, :post_ids, :text, null: true
  end
end
