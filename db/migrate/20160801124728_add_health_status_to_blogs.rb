class AddHealthStatusToBlogs < ActiveRecord::Migration[4.2]
  def change
    add_column :blogs, :health_status, :integer, default: 0
  end
end
