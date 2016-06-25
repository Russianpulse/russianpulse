class CreateAbTests < ActiveRecord::Migration
  def change
    create_table :ab_tests do |t|
      t.string :title
      t.string :path
      t.text :ga_code

      t.timestamps null: false
    end
  end
end
