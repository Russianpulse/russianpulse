class Add < ActiveRecord::Migration[4.2]
  def change
    add_column :blogs, :featured, :boolean
    add_index :blogs, :featured
  end
end
