class CreateAbTests < ActiveRecord::Migration[4.2]
  def change
    create_table :ab_tests do |t|
      t.string :title
      t.string :path
      t.text :ga_code

      t.timestamps null: false
    end
  end
end
