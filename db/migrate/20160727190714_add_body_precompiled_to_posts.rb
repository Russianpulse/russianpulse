class AddBodyPrecompiledToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :body_precompiled, :text
  end
end
