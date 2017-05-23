class RemoveRatingFromPosts < ActiveRecord::Migration[4.2]
  def change
    remove_column :posts, :base_rating, :float
    remove_column :posts, :rating, :float
  end
end
