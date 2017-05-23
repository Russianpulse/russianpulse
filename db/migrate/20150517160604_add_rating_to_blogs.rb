class AddRatingToBlogs < ActiveRecord::Migration[4.2]
  def change
    add_column :blogs, :rating, :float, default: 0
    add_index :blogs, :rating
  end
end
