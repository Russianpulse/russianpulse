class AddEnclosuresToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :enclosures, :text
  end
end
