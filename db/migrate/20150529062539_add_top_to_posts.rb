class AddTopToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :top, :boolean, default: false
    add_index :posts, :top
  end
end
