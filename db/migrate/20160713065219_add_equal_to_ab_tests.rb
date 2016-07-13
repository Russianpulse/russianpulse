class AddEqualToAbTests < ActiveRecord::Migration
  def change
    add_column :ab_tests, :equal, :boolean
  end
end
