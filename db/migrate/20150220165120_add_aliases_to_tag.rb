class AddAliasesToTag < ActiveRecord::Migration
  def change
    add_column :tags, :aliases, :text
  end
end
