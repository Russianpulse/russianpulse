class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :blog_id
      t.string :title
      t.text :body
      t.float :base_rating

      t.float :rating
      t.integer :views
      t.text :source_url
      t.datetime :accessed_at

      t.timestamps null: false
    end

    add_foreign_key :posts, :blogs, column: "blog_id"
  end
end
