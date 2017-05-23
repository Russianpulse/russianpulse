class AddEqualToAbTests < ActiveRecord::Migration[4.2]
  def change
    add_column :ab_tests, :equal, :boolean
  end
end
