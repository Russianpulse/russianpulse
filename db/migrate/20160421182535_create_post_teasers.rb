class CreatePostTeasers < ActiveRecord::Migration
  def change
    create_table :post_teasers do |t|
      t.text :body

      t.timestamps null: false
    end
  end
end
