class RenameBodyPrecompiledToBodyForPosts < ActiveRecord::Migration
  def change
    rename_column :posts, :body_precompiled, :body
  end
end
