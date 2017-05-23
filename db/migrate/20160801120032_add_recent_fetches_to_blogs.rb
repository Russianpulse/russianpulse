class AddRecentFetchesToBlogs < ActiveRecord::Migration[4.2]
  def change
    add_column :blogs, :recent_fetches, :text
  end
end
