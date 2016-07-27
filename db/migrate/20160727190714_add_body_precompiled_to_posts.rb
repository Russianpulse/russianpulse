class AddBodyPrecompiledToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :body_precompiled, :text
  end
end
