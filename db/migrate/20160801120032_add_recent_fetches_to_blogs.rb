class AddRecentFetchesToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :recent_fetches, :text
  end
end
