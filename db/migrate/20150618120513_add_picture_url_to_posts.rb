class AddPictureUrlToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :picture_url, :text
  end
end
