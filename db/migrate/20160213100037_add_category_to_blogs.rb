class AddCategoryToBlogs < ActiveRecord::Migration[4.2]
  def change
    add_column :blogs, :category, :string
  end
end
