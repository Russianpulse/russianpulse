class AddBodyCleanupRulesToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :text_cleanup_rules, :text
  end
end
