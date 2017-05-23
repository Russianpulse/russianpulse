class FixNullsPostBlog < ActiveRecord::Migration[4.2]
  def change
    change_column :blogs, :rating, :float, default: 0, null: false
    change_column :posts, :views, :integer, default: 0, null: false
  end
end
