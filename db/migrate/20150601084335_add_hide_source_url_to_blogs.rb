class AddHideSourceUrlToBlogs < ActiveRecord::Migration[4.2]
  def change
    add_column :blogs, :hide_source_url, :boolean, default: false, null: false
  end
end
