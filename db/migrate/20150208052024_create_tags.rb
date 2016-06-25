class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :title
      t.string :slug

      t.timestamps null: false
    end

    add_index :tags, :slug, :unique => true
  end
end
