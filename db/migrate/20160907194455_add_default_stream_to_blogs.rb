class AddDefaultStreamToBlogs < ActiveRecord::Migration[5.0]
  def change
    add_column :blogs, :default_stream, :string, default: 'inbox', null: false
  end
end
