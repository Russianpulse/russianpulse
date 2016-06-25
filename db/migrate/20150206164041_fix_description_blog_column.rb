class FixDescriptionBlogColumn < ActiveRecord::Migration
  def change
    rename_column :blogs, :dscription, :description
  end
end
