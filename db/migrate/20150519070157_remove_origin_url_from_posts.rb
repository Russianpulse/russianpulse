class RemoveOriginUrlFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :origin_url, :text
  end
end
