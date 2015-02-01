class AddHideSourceUrlToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :hide_source_url, :boolean, default: false, null: false
  end
end
