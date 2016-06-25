class RemoveRatingFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :base_rating, :float
    remove_column :posts, :rating, :float
  end
end
