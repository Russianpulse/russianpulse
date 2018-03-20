class CreateBlogsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :blogs_users do |t|
      t.integer :user_id, null: false
      t.integer :blog_id, null: false
      t.string :role, null: false
    end

    add_foreign_key :blogs_users, :users
    add_foreign_key :blogs_users, :blogs
  end
end
