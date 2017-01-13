class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :dscription
      t.string :slug, null: false
      t.text :feed_url
      t.text :avatar_url
      t.datetime :checked_at
      t.string :fetch_type
      t.float :posts_per_hour

      t.timestamps null: false
    end

    add_index :blogs, :slug, unique: true
  end
end
