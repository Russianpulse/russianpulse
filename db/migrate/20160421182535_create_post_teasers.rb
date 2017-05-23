class CreatePostTeasers < ActiveRecord::Migration[4.2]
  def change
    create_table :post_teasers do |t|
      t.text :body

      t.timestamps null: false
    end
  end
end
