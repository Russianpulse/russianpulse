class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :user_id
      t.text :blog_ids, null: false, default: [].to_json

      t.timestamps null: false
    end

    add_index :subscriptions, :user_id, unique: true
  end
end
