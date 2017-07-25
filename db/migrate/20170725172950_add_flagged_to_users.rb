class AddFlaggedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :flagged, :boolean
  end
end
