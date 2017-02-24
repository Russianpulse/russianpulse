class AddTypeToBlogs < ActiveRecord::Migration[5.0]
  def change
    add_column :blogs, :type, :string
    BlogBase.update_all(type: 'Blog')
  end
end
