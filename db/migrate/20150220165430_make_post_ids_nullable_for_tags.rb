class MakePostIdsNullableForTags < ActiveRecord::Migration[4.2]
  def change
    change_column :tags, :post_ids, :text, null: true
  end
end
