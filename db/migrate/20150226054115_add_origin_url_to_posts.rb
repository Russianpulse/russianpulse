class AddOriginUrlToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :origin_url, :text
  end
end
