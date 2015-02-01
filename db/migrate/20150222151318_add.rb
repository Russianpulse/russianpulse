class Add < ActiveRecord::Migration
  def change
    add_column :blogs, :featured, :boolean
    add_index :blogs, :featured
  end
end
