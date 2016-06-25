class AddPictureUrlToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :picture_url, :text
  end
end
