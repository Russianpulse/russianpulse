class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.string :key, :null => false
      t.text :body

      t.timestamps null: false
    end

    add_index :snippets, :key, :unique => true
  end
end
