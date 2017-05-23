class FixDescriptionBlogColumn < ActiveRecord::Migration[4.2]
  def change
    rename_column :blogs, :dscription, :description
  end
end
