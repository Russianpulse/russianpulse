class AddOriginUrlToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :origin_url, :text
  end
end
