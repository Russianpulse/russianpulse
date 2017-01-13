class CreatePostDigests < ActiveRecord::Migration
  def change
    create_table :post_digests do |t|
      t.string :title
      t.string :slug, null: false
      t.text :description
      t.text :post_ids

      t.timestamps null: false
    end
    add_index :post_digests, :slug, unique: true
  end
end
