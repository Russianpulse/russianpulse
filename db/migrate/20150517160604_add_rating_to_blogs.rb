class AddRatingToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :rating, :float, :default => 0
    add_index :blogs, :rating
  end
end
