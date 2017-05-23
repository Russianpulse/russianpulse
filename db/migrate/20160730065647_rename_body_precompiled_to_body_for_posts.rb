class RenameBodyPrecompiledToBodyForPosts < ActiveRecord::Migration[4.2]
  def change
    rename_column :posts, :body_precompiled, :body
  end
end
