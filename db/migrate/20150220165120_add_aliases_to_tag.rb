class AddAliasesToTag < ActiveRecord::Migration[4.2]
  def change
    add_column :tags, :aliases, :text
  end
end
