class AddTagsListToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :tags_list, :text
  end
end
