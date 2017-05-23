class AddTagsListToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :tags_list, :text
  end
end
