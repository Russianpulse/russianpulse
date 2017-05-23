class AddBodyCleanupRulesToBlogs < ActiveRecord::Migration[4.2]
  def change
    add_column :blogs, :text_cleanup_rules, :text
  end
end
