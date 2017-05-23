class AddSlugIdToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :slug_id, :string
    add_index :posts, :slug_id, unique: true
  end
end
