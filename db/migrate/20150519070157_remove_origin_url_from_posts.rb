class RemoveOriginUrlFromPosts < ActiveRecord::Migration[4.2]
  def change
    remove_column :posts, :origin_url, :text
  end
end
