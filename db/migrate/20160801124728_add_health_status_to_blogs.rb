class AddHealthStatusToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :health_status, :integer, default: 0
  end
end
