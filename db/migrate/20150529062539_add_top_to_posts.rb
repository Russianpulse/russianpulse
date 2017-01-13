class AddTopToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :top, :boolean, default: false
    add_index :posts, :top
  end
end
